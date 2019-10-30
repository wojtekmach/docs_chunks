defmodule DocsChunks.MixProject do
  use Mix.Project
  @version "0.1.0"

  def project do
    [
      app: :docs_chunks,
      version: @version,
      elixir: "~> 1.9",
      language: :erlang,
      escript: escript(),
      aliases: aliases()
    ]
  end

  def application() do
    [
      extra_applications: [:xmerl]
    ]
  end

  def escript() do
    [main_module: :docs_chunks_cli]
  end

  defp aliases() do
    [
      all_docs: [
        "docs", "telemetry_docs", "hex_core_docs", "brod_docs", "otp_docs"
      ],
      docs: [
        "escript.build",
        "cmd ./docs_chunks -project",
        "cmd ex_doc docs_chunks #{@version} _build/dev/lib/docs_chunks/ebin --main docs_chunks --output docs/docs_chunks"
      ],
      otp: [
        "escript.build",
        "cmd ./docs_chunks -otp-xml-stdlib ~/src/otp"
      ],
      otp_docs: [
        "otp",
        "cmd ex_doc stdlib 22.1.4 ~/.asdf/installs/erlang/22.1.4/lib/stdlib-3.10/ebin/ --main array --output docs/stdlib"
      ],
      telemetry_chunks: [
        "escript.build",
        &telemetry_chunks/1
      ],
      telemetry_docs: [
        "telemetry_chunks",
        "cmd ex_doc telemetry 0.4.0 ../telemetry/_build/default/lib/telemetry/ebin --main telemetry --output docs/telemetry -u https://github.com/beam-telemetry/telemetry --source-ref v0.4.0 --source-root ../telemetry"
      ],
      hex_core_chunks: [
        "escript.build",
        &hex_core_chunks/1
      ],
      hex_core_docs: [
        "hex_core_chunks",
        "cmd ex_doc hex_core 0.6.1 ../hex_core/_build/default/lib/hex_core/ebin --main hex_core --output docs/hex_core"
      ],
      brod_chunks: [
        "escript.build",
        &brod_chunks/1
      ],
      brod_docs: [
        "brod_chunks",
        "cmd ex_doc brod master ../brod/_build/default/lib/brod/ebin --main brod --output docs/brod"
      ]
    ]
  end

  defp telemetry_chunks(_), do: docs_chunks("../telemetry")

  defp hex_core_chunks(_), do: docs_chunks("../hex_core")

  defp brod_chunks(_), do: docs_chunks("../brod")

  defp docs_chunks(path) do
    {_, 0} = System.cmd("rebar3", ~w(compile), cd: path, into: IO.stream(:stdio, :line))
    bin = "../docs_chunks/docs_chunks"
    {_, _} = System.cmd(bin, ~w(-project), cd: path, into: IO.stream(:stdio, :line))
  end
end
