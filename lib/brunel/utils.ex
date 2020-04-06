defmodule Brunel.Utils do
  def load_zip(filename) do
    filename
    |> String.to_charlist()
    |> :zip.zip_open([:memory])
  end

  def csv_from_zip(filename, handle) do
    filename =
      filename
      |> String.to_charlist()

    with {:ok, {_, contents}} <- :zip.zip_get(filename, handle),
         {:ok, io} <- StringIO.open(contents) do
      io
      |> IO.binstream(:line)
      |> CSV.decode(headers: true)
      |> Enum.map(fn {:ok, value} -> value end)
      |> Enum.map(fn x -> atomize_map_keys(x) end)
    end
  end

  def atomize_map_keys(map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end

  def recursive_struct(list, strukt) do
    list
    |> Enum.map(fn x -> struct(strukt, x) end)
  end
end
