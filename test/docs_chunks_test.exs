defmodule DocsChunksTest do
  use ExUnit.Case, async: true

  test "edoc" do
    beam_path = "_build/test/lib/docs_chunks/ebin/docs_chunks.beam"
    {:ok, _} = :beam_lib.strip_files([String.to_charlist(beam_path)])
    assert {:error, :chunk_not_found} = Code.fetch_docs(beam_path)

    chunk = :docs_chunks.edoc_to_chunk('src/docs_chunks.erl')
    {:docs_v1, _, :erlang, _, %{"en" => moduledoc}, _, docs} = chunk
    assert moduledoc == "A module to extract docs and attach them as chunks."
    [_, {{:function, :edoc_to_chunk, 1}, _anno, _signature, %{"en" => doc}, _metadata} | _] = docs
    assert doc =~ "Fetch edoc docs from a given `ErlPath` and convert it to docs chunk."

    :ok = :docs_chunks.write_chunk(String.to_charlist(beam_path), chunk)
    assert {:docs_v1, _, :erlang, _, _, _, _} = Code.fetch_docs(beam_path)

    require IEx.Helpers
    IEx.Helpers.h(:docs_chunks.edoc_to_chunk())
  end

  @module :beam_lib

  test "otp" do
    chunk =
      :docs_chunks.otp_xml_to_chunk('/Users/wojtek/src/otp', 'lib/stdlib/doc/src/#{@module}.xml')

    :ok = :docs_chunks.write_chunk(:code.which(@module), chunk)
    assert {:docs_v1, _, _, _, _, _, _} = Code.fetch_docs(@module)

    require IEx.Helpers
    IEx.Helpers.h(@module)
  end
end
