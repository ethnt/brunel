defmodule Brunel.Utils.Zip do
  @moduledoc """
  Utilities for dealing with zip files.
  """

  @typedoc """
  A shortcut to a zip handle.
  """
  @type handle :: :zip.handle()

  @doc """
  Load a zip file, into memory by default.
  """
  @spec load(String.t(), [:memory | :cooked]) :: {:ok, handle()} | {:error, any}
  def load(file, opts \\ [:memory]) do
    file
    |> String.to_charlist()
    |> :zip.zip_open(opts)
  end

  @doc """
  Get a file from a zip file and turn it into an IO stream.
  """
  @spec get(String.t(), handle()) :: IO.Stream.t()
  def get(filename, handle) do
    {:ok, {_, contents}} =
      filename
      |> String.to_charlist()
      |> :zip.zip_get(handle)

    {:ok, file} = StringIO.open(contents)

    IO.stream(file, :line)
  end
end
