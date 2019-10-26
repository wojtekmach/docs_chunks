%% @doc A module to extract docs and attach them as chunks.
-module(docs_chunks).
-include_lib("xmerl/include/xmerl.hrl").
-export([edoc_to_chunk/1, otp_xml_to_chunk/2, write_chunk/2, '__info__'/1]).

-record(docs_v1, {anno,
                  beam_language,
                  format,
                  module_doc,
                  metadata,
                  docs}).

-record(docs_v1_entry, {kind_name_arity,
                        anno,
                        signature,
                        doc,
                        metadata}).

-type docs_v1() :: #docs_v1{anno :: erl_anno:anno(),
                            beam_language :: beam_language(),
                            format :: mime_type(),
                            module_doc :: doc(),
                            metadata :: metadata(),
                            docs :: [docs_v1_entry()]}.

-type docs_v1_entry() :: #docs_v1_entry{kind_name_arity :: {atom(), atom(), arity()},
                                        anno :: erl_anno:anno(),
                                        signature :: signature(),
                                        doc :: doc(),
                                        metadata :: metadata()}.

-type beam_language() :: atom().

-type mime_type() :: binary().

-type doc() :: #{doc_language() => doc_string()} | none | hidden.

-type doc_language() :: binary().

-type doc_string() :: binary().

-type metadata() :: map().

-type signature() :: [binary()].

%% TODO: hack to get ExDoc to not crash.
'__info__'(compile) ->
    [
     {source, "src/docs_chunks.erl"}
    ].

%% @doc Fetch edoc docs from a given `ErlPath' and convert it to docs chunk.
%%
%% http://erlang.org/eeps/eep-0048.html
%%
%% Examples:
%%
%% ```
%% %% docs_chunks:edoc_to_chunk("src/foo.erl").
%% #=> {docs_v1, ..., erlang, <<"text/markdown">>", ..., ..., ..., ...}
%% '''
-spec edoc_to_chunk(string()) -> docs_v1().
edoc_to_chunk(ErlPath) ->
    {_Module, Doc} = edoc:get_doc(ErlPath, [{preprocess, true}]),
    DocString = xpath_to_binary("//module/description/fullDescription", Doc),
    Docs = edoc_extract_docs(Doc),
    Chunk = docs_v1(DocString, Docs),
    % 'Elixir.IO':inspect(Chunk),
    Chunk.

% TODO: extract types and callbacks too
edoc_extract_docs(Doc) ->
    [edoc_extract_function(Doc1) || Doc1 <- xmerl_xpath:string("//module/functions/function", Doc)].

edoc_extract_function(Doc) ->
    Name = xpath_to_atom("./@name", Doc),
    Arity = xpath_to_integer("./@arity", Doc),
    DocString =
        case xmerl_xpath:string("./equiv", Doc) of
            [Equiv] ->
                iolist_to_binary(["Equivalent to ", xpath_to_binary("./expr", Equiv), "."]);

            [] ->
                xpath_to_binary("./description/fullDescription", Doc)
        end,
    docs_v1_function(Name, Arity, DocString).

% %% @doc Extract XML docs from `XMLPath' in `OTPRootDir' and convert it to docs chunk.
otp_xml_to_chunk(OTPRootDir, XMLPath) ->
    Doc = load_otp_xml(OTPRootDir, filename:join([OTPRootDir, XMLPath])),
    DocString = xpath_to_binary("//description", Doc),
    Docs = otp_xml_extract_docs(Doc, XMLPath),
    docs_v1(DocString, Docs).

% TODO: extract types and callbacks too
otp_xml_extract_docs(Doc, XMLPath) ->
    List = [otp_xml_extract_function(Doc1, XMLPath) || Doc1 <- xmerl_xpath:string("./funcs/func", Doc)],
    lists:filter(fun(Elem) -> Elem /= skip end, List).

otp_xml_extract_function(Doc, XMLPath) ->
    % 'Elixir.IO':inspect(xmerl_xpath:string("./name/@name", Doc)),
    Name = xpath_to_atom("./name/@name", Doc),

    case Name == '' of
        true ->
            warn_unparsable(Doc, XMLPath),
            skip;
        false ->
            Arity = xpath_to_integer("./name/@arity", Doc),
            DocString = xpath_to_binary("./desc", Doc),

            % case Name of
            %     take ->
            %         'Elixir.IO':inspect(xmerl_xpath:string("//desc", Doc)),
            %         'Elixir.IO':inspect(DocString),
            %         ok;

            %     _ ->
            %         ok
            % end,

            docs_v1_function(Name, Arity, DocString)
    end.

% TODO: example warning:
%
%   gen_server.xml: cannot parse call(ServerRef, Request) -> Reply
%
% so pretty important function! Need to gracefully handle this.
warn_unparsable(Doc, XMLPath) ->
    Head = to_markdown(xmerl_xpath:string("//name[1]/text()", Doc)),
    io:fwrite("~s: cannot parse ~s~n", [XMLPath, Head]).


load_otp_xml(OTPRootDir, XMLPath) ->
    Options = [
               % {space, normalize},
               {fetch_path, [OTPRootDir ++ "/lib/erl_docgen/priv/dtd",
                             OTPRootDir ++ "/lib/erl_docgen/priv/dtd_html_entities" ]}],
    XMLPath2 = filename:join([OTPRootDir, XMLPath]),
    {Doc, []} = xmerl_scan:file(XMLPath2, Options),
    Doc.

%% @doc Append given `Chunk' to `BeamPath'.
write_chunk(BeamPath, Chunk) ->
    {ok, _Module, Chunks} = beam_lib:all_chunks(BeamPath),
    NewChunks = lists:keystore("Docs", 1, Chunks, {"Docs", term_to_binary(Chunk)}),
    {ok, Binary} = beam_lib:build_module(NewChunks),
    file:write_file(BeamPath, Binary).

%%
%% Utilities
%%

docs_v1(DocString, Docs) ->
    % TODO fill these in
    Anno = 0,
    BeamLanguage = erlang,
    Format = <<"text/markdown">>,
    Metadata = #{},
    Doc = doc_string_to_doc(DocString, hidden),
    {docs_v1, Anno, BeamLanguage, Format, Doc, Metadata, Docs}.

docs_v1_function(Name, Arity, DocString) ->
    % TODO fill these in
    Anno = 0,
    % TODO get signature from abstract code
    Signature = [list_to_binary(atom_to_list(Name) ++ "/" ++ integer_to_list(Arity))],
    Metadata = #{},
    Doc = doc_string_to_doc(DocString, none),
    {{function, Name, Arity}, Anno, Signature, Doc, Metadata}.

doc_string_to_doc(<<"">>, Empty) -> Empty;
doc_string_to_doc(DocString, _Empty) when is_binary(DocString) -> #{<<"en">> => DocString}.

xpath_to_binary(XPath, Doc) ->
    to_markdown(xmerl_xpath:string(XPath, Doc)).

xpath_to_atom(XPath, Doc) ->
    binary_to_atom(to_markdown(xmerl_xpath:string(XPath, Doc)), utf8).

xpath_to_integer(XPath, Doc) ->
    binary_to_integer(to_markdown(xmerl_xpath:string(XPath, Doc))).

to_markdown(Term) ->
    iolist_to_binary(do_to_markdown(Term)).

do_to_markdown(List) when is_list(List) ->
    lists:join("", lists:map(fun do_to_markdown/1, List));
do_to_markdown(#xmlElement{name=p, content=Content}) ->
    [do_to_markdown(Content), "\n\n"];
do_to_markdown(#xmlElement{name=pre, content=Content}) ->
    code_block(Content);
do_to_markdown(#xmlElement{name=c, content=Content}) ->
    code_inline(Content);
do_to_markdown(#xmlElement{name=expr, content=Content}) ->
    code_inline(Content);
do_to_markdown(#xmlElement{name=code, content=Content}) ->
    case is_otp_xml(Content) of
        true -> code_block(Content);
        false -> code_inline(Content)
    end;
do_to_markdown(#xmlElement{name=item, content=Content}) ->
    ["  * ", do_to_markdown(Content)];
do_to_markdown(#xmlElement{content=Content}) ->
    do_to_markdown(Content);
do_to_markdown(#xmlAttribute{value=Value}) ->
    to_binary(Value);
do_to_markdown(#xmlText{value=Value}) ->
    clean_whitespace(Value).

clean_whitespace(Value) ->
    re:replace(unicode:characters_to_binary(Value), "\\s+", " ", [global]).

code_block(List) when is_list(List) ->
    [
     "\n```\n",
     trim_leading(lists:join("", lists:map(fun code_block/1, List)), "\n"),
     "\n```\n"
    ];
code_block(#xmlText{value=Value}) ->
    to_binary(Value);
code_block(#xmlElement{name=input, content=[#xmlText{value=Value}]}) ->
    to_binary(Value);
code_block(#xmlElement{name=anno, content=[#xmlText{value=Value}]}) ->
    to_binary(Value).

code_inline(List) when is_list(List) ->
    lists:join("", lists:map(fun code_inline/1, List));
code_inline(#xmlElement{name=anno, content=[#xmlText{} = XmlText]}) ->
    code_inline(XmlText);
code_inline(#xmlText{value=Value}) ->
    ["`", to_binary(Value), "`"].

to_binary(String) ->
    unicode:characters_to_binary(String).

trim_leading(String, Trim) ->
      re:replace(unicode:characters_to_binary(String), "^" ++ Trim, "", [global]).

is_otp_xml(List) when is_list(List) ->
    lists:any(fun
                  (#xmlText{parents=Parents}) ->
                      proplists:get_value(erlref, Parents) /= undefined;
                  (_) ->
                      false
              end, List).
