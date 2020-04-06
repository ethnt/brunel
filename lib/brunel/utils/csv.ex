defmodule Brunel.Utils.CSV do
  @moduledoc """
  Utilities for dealing with CSVs.
  """

  @doc """
  Parse a CSV from a stream.
  """
  def parse(stream, opts \\ [headers: true]) do
    stream
    |> CSV.decode(opts)
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
