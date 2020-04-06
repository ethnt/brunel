defmodule Brunel.Utils.ZIP do
  @moduledoc """
  Utilities for dealing with ZIP files.
  """

  @typedoc """
  Represents a ZIP "handle" (the PID to the process that is handling it)
  """
  @type zip_handle :: :zip.handle()

  @doc """
  Load a ZIP file.

      iex> Brunel.Utils.ZIP.load("/Users/brunel/Downloads/gtfs.zip")
      {:ok, #PID<0.284.0>}
  """
  @spec load(String.t(), [:memory | :cooked]) :: {:error, any} | {:ok, zip_handle}
  def load(filename, opts \\ [:memory]) do
    filename
    |> String.to_charlist()
    |> :zip.zip_open(opts)
  end

  @doc """
  Extract a file from a ZIP.

      iex> Brunel.Utils.ZIP.get(handle, "agency.txt")
      {:ok, <Stream>}
  """
  def get(handle, filename) do
    filename = filename |> String.to_charlist()

    with {:ok, {_, contents}} <- :zip.zip_get(filename, handle),
         {:ok, io} <- StringIO.open(contents),
         stream <- IO.binstream(io, :line) do
      {:ok, stream}
    end
  end
end
