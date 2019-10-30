defmodule DocsChunksTest do
  use ExUnit.Case, async: true

  test "edoc" do
    beam_path = "_build/test/lib/docs_chunks/ebin/docs_chunks.beam"
    {:ok, _} = :beam_lib.strip_files([String.to_charlist(beam_path)])
    assert {:error, :chunk_not_found} = Code.fetch_docs(beam_path)

    chunk = :docs_chunks.edoc_to_chunk('src/docs_chunks.erl')
    {:docs_v1, _, :erlang, _, %{"en" => moduledoc}, metadata, entries} = chunk
    assert moduledoc == "A module to extract docs and attach them as chunks."
    assert metadata == %{since: "0.1.0"}

    entry1 = List.keyfind(entries, {:type, :docs_v1, 0}, 0)
    {_, _anno, signature, doc, metadata} = entry1
    assert signature == ["docs_v1/0"]
    assert doc == %{"en" => " The Docs v1 chunk according to EEP 48."}
    assert metadata == %{}

    entry2 = List.keyfind(entries, {:function, :edoc_to_chunk, 1}, 0)
    {_, _anno, signature, %{"en" => doc}, metadata} = entry2
    assert signature == ["edoc_to_chunk/1"]
    assert doc =~ "Fetch edoc docs from a given `ErlPath` and convert it to docs chunk."
    assert metadata == %{since: "0.0.1"}

    :ok = :docs_chunks.write_chunk(String.to_charlist(beam_path), chunk)
    assert {:docs_v1, _, :erlang, _, _, _, _} = Code.fetch_docs(beam_path)

    # require IEx.Helpers
    # IEx.Helpers.h(:docs_chunks.edoc_to_chunk())
  end

  @module :maps

  test "otp" do
    chunk =
      :docs_chunks.otp_xml_to_chunk('/Users/wojtek/src/otp', 'lib/stdlib/doc/src/#{@module}.xml')

    :ok = :docs_chunks.write_chunk(:code.which(@module), chunk)
    assert {:docs_v1, _, _, _, _, _, _} = Code.fetch_docs(@module)

    require IEx.Helpers
    IEx.Helpers.h(@module.take / 2)
  end
end
