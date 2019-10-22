%% @doc A module to extract docs and attach them as chunks.
-module(docs_chunks).
-include_lib("xmerl/include/xmerl.hrl").
-export([edoc_to_chunk/1, otp_xml_to_chunk/2, write_chunk/2, '__info__'/1]).

%% TODO: hack to get ExDoc to not crash.
'__info__'(compile) ->
    [
     {source, "src/docs_chunks.erl"}
    ].

%% @doc Fetch edoc docs from a given `ErlPath' and convert it to docs chunk.
%% http://erlang.org/eeps/eep-0048.html
edoc_to_chunk(ErlPath) ->
    {_Module, Doc} = edoc:get_doc(ErlPath),
    DocString = xpath_to_binary("//module/description/fullDescription", Doc),
    Docs = edoc_extract_docs(Doc),
    docs_v1(DocString, Docs).

% TODO: extract types and callbacks too
edoc_extract_docs(Doc) ->
    [edoc_extract_function(Doc1) || Doc1 <- xmerl_xpath:string("//module/functions/function", Doc)].

edoc_extract_function(Doc) ->
    Name = xpath_to_atom("//@name", Doc),
    Arity = xpath_to_integer("//@arity", Doc),
    DocString = xpath_to_binary("//description/fullDescription", Doc),
    docs_v1_function(Name, Arity, DocString).

%% @doc Extract XML docs from `XMLPath' in `OTPRootDir' and convert it to docs chunk.
otp_xml_to_chunk(OTPRootDir, XMLPath) ->
    Doc = load_otp_xml(OTPRootDir, filename:join([OTPRootDir, XMLPath])),
    DocString = xpath_to_binary("//description", Doc),
    Docs = otp_xml_extract_docs(Doc, XMLPath),
    docs_v1(DocString, Docs).

% TODO: extract types and callbacks too
otp_xml_extract_docs(Doc, XMLPath) ->
    List = [otp_xml_extract_function(Doc1, XMLPath) || Doc1 <- xmerl_xpath:string("//funcs/func", Doc)],
    lists:filter(fun(Elem) -> Elem /= skip end, List).

otp_xml_extract_function(Doc, XMLPath) ->
    Name = xpath_to_atom("//@name", Doc),

    case Name == '' of
        true ->
            warn_unparsable(Doc, XMLPath),
            skip;
        false ->
            Arity = xpath_to_integer("//@arity", Doc),
            DocString = xpath_to_binary("//desc", Doc),
            docs_v1_function(Name, Arity, DocString)
    end.

% TODO: example warning:
%
%   gen_server.xml: cannot parse call(ServerRef, Request) -> Reply
%
% so pretty important function! Need to gracefully handle this.
warn_unparsable(Doc, XMLPath) ->
    Head = textify(xmerl_xpath:string("//name[1]/text()", Doc)),
    io:fwrite("~s: cannot parse ~s~n", [XMLPath, Head]).


load_otp_xml(OTPRootDir, XMLPath) ->
    Options = [{space, normalize},
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
    Format = <<"text/plain">>,
    Metadata = #{},
    {docs_v1, Anno, BeamLanguage, Format, #{<<"en">> => DocString}, Metadata, Docs}.

docs_v1_function(Name, Arity, <<"">>) ->
    % TODO fill these in
    Anno = 0,
    Signature = [],
    Metadata = #{},
    {{function, Name, Arity}, Anno, Signature, none, Metadata};

docs_v1_function(Name, Arity, DocString) ->
    % TODO fill these in
    Anno = 0,
    % TODO get signature from abstract code
    Signature = [list_to_binary(atom_to_list(Name) ++ "/" ++ integer_to_list(Arity))],
    Metadata = #{},
    {{function, Name, Arity}, Anno, Signature, #{<<"en">> => DocString}, Metadata}.

xpath_to_binary(XPath, Doc) ->
    textify(xmerl_xpath:string(XPath, Doc)).

xpath_to_atom(XPath, Doc) ->
    binary_to_atom(textify(xmerl_xpath:string(XPath, Doc)), utf8).

xpath_to_integer(XPath, Doc) ->
    binary_to_integer(textify(xmerl_xpath:string(XPath, Doc))).
    % case textify(xmerl_xpath:string(XPath, Doc)) of
    %     <<"">> -> nil;
    %     Binary -> binary_to_integer(Binary)
    % end.

textify(Term) ->
    iolist_to_binary(do_textify(Term)).

do_textify(List) when is_list(List) ->
    lists:join("", lists:map(fun do_textify/1, List));
do_textify(#xmlElement{name=p, content=Content}) ->
    [do_textify(Content), "\n\n"];
do_textify(#xmlElement{name=pre, content=Content}) ->
    ["```\n", do_textify(Content), "\n```\n\n"];
do_textify(#xmlElement{name=c, content=Content}) ->
    ["`", do_textify(Content), "`"];
do_textify(#xmlElement{content=Content}) ->
    do_textify(Content);
do_textify(#xmlAttribute{value=Value}) ->
    unicode:characters_to_binary(Value);
do_textify(#xmlText{value=Value}) ->
    unicode:characters_to_binary(Value).
