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
      docs:
        "cmd ex_doc docs_chunks #{@version} _build/dev/lib/docs_chunks/ebin --main docs_chunks --output docs"
    ]
  end
end
