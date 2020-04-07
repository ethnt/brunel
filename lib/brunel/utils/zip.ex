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
  @spec get(String.t(), handle()) :: {:ok, IO.Stream.t()} | {:error, any}
  def get(filename, handle) do
    filename = filename |> String.to_charlist()

    with {:ok, {_, contents}} <- :zip.zip_get(filename, handle),
         {:ok, file} <- StringIO.open(contents) do
      {:ok, IO.stream(file, :line)}
    else
      err -> err
    end
  end
end
