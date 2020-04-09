defmodule Brunel.Dataset do
  @moduledoc """
  A set of GTFS data.
  """

  defstruct ~w(source)a

  alias Brunel.{Agency, Route, Stop, Trip, StopTime, Utils}

  @typedoc """
  Represents a complete Brunel dataset.
  """
  @type t :: %__MODULE__{
          source: Utils.Zip.handle()
        }

  @spec load(String.t()) :: {:error, any} | {:ok, Brunel.Dataset.t()}
  def load(filename) do
    with {:ok, handle} <- Utils.Zip.load(filename) do
      dataset =
        %Brunel.Dataset{source: handle}
        |> Agency.load()
        |> Route.load()
        |> Stop.load()
        |> Trip.load()
        |> StopTime.load()

      {:ok, dataset}
    end
  end
end
