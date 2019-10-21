-module(docs_chunks_cli).
-export([main/1, '__info__'/1]).

%% TODO: hack to get ExDoc to not crash.
'__info__'(_) ->
    [].

main(["-edoc", ErlPath, LibDir]) ->
    Basename = filename:basename(ErlPath, ".erl"),
    BeamPath = filename:join([LibDir, Basename ++ ".beam"]),
    puts(["Reading " ++ ErlPath]),
    Chunks = docs_chunks:edoc_to_chunk(ErlPath),
    puts(["Writing " ++ BeamPath]),
    ok = docs_chunks:write_chunk(BeamPath, Chunks);

main(["-otp-xml", OTPRootDir, ModuleString]) ->
    Module = list_to_atom(ModuleString),
    {ok, App} = application:get_application(Module),
    XMLPath = filename:join([OTPRootDir, "lib", atom_to_list(App), "doc", "src",
                             atom_to_list(Module) ++ ".xml"]),
    case filelib:is_file(XMLPath) of
        true ->
            puts(["Reading " ++ XMLPath]),
            Chunks = docs_chunks:otp_xml_to_chunk(OTPRootDir, XMLPath),
            BeamPath = code:which(Module),
            puts(["Writing " ++ BeamPath]),
            ok = docs_chunks:write_chunk(BeamPath, Chunks);
        false ->
            puts(["Skipping " ++ XMLPath ++ ", file does not exist"])
    end;

main(["-otp-xml-stdlib", OTPRootDir]) ->
    {ok, Modules} = application:get_key(stdlib, modules),
    [main(["-otp-xml", OTPRootDir, atom_to_list(Module)]) || Module <- Modules];

main(["-project"]) ->
    {ok, Cwd} = file:get_cwd(),
    Project = filename:basename(Cwd),
    Segment =
        case filelib:is_file("mix.exs") of
            true ->
                "dev";
            false ->
                case filelib:is_file("rebar.config") of
                    true ->
                        "default";
                    false ->
                        io:fwrite("cannot find mix.exs or rebar.config file"),
                        erlang:halt(1)
                end
        end,
    LibDir = filename:join(["_build", Segment, "lib", Project, "ebin"]),
    [main(["-edoc", ErlPath, LibDir]) || ErlPath <- filelib:wildcard("src/*.erl")],
    ok;

main(Args) ->
    io:fwrite("debug: ~p~n", [Args]),

    puts([
        "Usage:",
        "",
        "  docs_chunks -edoc ERL_PATH LIB_DIR",
        "  docs_chunks -otp-xml OTP_ROOT_DIR MODULE",
        "  docs_chunks -otp-xml-stdlib OTP_ROOT_DIR",
        "  docs_chunks -project",
        ""]),
    erlang:halt(1).

puts(Lines) ->
    io:fwrite(lists:flatten(lists:join("~n", Lines ++ [""]))).
