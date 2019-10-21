# docs_chunks

A tool to extract EDoc or OTP XML documentation and attach it as Docs chunk.

## Usage

By default Erlang modules don't have docs chunks and so `iex> h` will not find docs:

    iex> h :sets
    #=> :erlang was not compiled with docs

Install `docs_chunks`:

    mix escript.install github wojtekmach/docs_chunks

Attach chunks for the `sets` module:

    docs_chunks -otp-xml $HOME/src/otp sets
    #=> Reading /Users/wojtek/src/otp/lib/stdlib/doc/src/sets.xml
    #=> Writing /Users/wojtek/.asdf/installs/erlang/22.1.3/lib/stdlib-3.10/ebin/sets.beam

Note your OTP installation likely does not have documentation XMLs and in that case clone
erlang/otp repository and pass that as the given OTP path.

Now `iex> h` works:

    iex> h :sets

                                         :sets

    Sets are collections of elements with no duplicate elements. The representation (...)

You can create docs chunks for the stdlib app like this:

    docs_chunks -otp-xml-stdlib $HOME/src/otp
    #=> Reading /Users/wojtek/src/otp/lib/stdlib/doc/src/array.xml
    #=> Writing /Users/wojtek/.asdf/installs/erlang/22.1.3/lib/stdlib-3.10/ebin/array.beam
    #=> Reading /Users/wojtek/src/otp/lib/stdlib/doc/src/base64.xml
    #=> Writing /Users/wojtek/.asdf/installs/erlang/22.1.3/lib/stdlib-3.10/ebin/base64.beam
    #=> ...)

### Erlang Projects

Let's now attach docs chunks for an Erlang project, for example... the `docs_chunks` project itself:

    git clone wojtekmach/docs_chunks
    cd docs_chunks
    mix compile
    docs_chunks -edoc src/docs_chunks.erl _build/dev/lib/docs_chunks/ebin/
    #=> Reading src/docs_chunks.erl
    #=> Writing _build/dev/lib/docs_chunks/ebin/docs_chunks.beam

If your project is built with Mix or Rebar3, you can use this shortcut too:

    docs_chunks -project
    #=> Reading src/docs_chunks.erl
    #=> Writing _build/dev/lib/docs_chunks/ebin/docs_chunks.beam
    #=> Reading src/docs_chunks_cli.erl
    #=> Writing _build/dev/lib/docs_chunks/ebin/docs_chunks_cli.beam

    iex -S mix
    iex> h :docs_chunks

                                      :docs_chunks

    A module to extract docs and attach them as chunks.

### ExDoc

Since we have docs chunks attached to beam files we can use ExDoc:

    mix escript.install hex ex_doc
    ex_doc docs_chunks "0.1.0" _build/dev/lib/docs_chunks/ebin --main docs_chunks

If everything went well you should see docs like these: [wojtekmach.github.io/docs_chunks](http://wojtekmach.github.io/docs_chunks).

## License

Apache-2.0
