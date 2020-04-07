defmodule Brunel.Dataset do
  @moduledoc """
  A set of GTFS data.
  """

  defstruct ~w(source agencies stops stop_times trips)a

  alias Brunel.{Agency, Stop, StopTime, Trip, Utils}

  @typedoc """
  Represents a complete Brunel dataset.
  """
  @type t :: %__MODULE__{
          source: :zip.handle(),
          agencies: list(Agency.t()) | nil,
          stops: list(Stop.t()) | nil,
          stop_times: list(StopTime.t()) | nil,
          trips: list(Trip.t()) | nil
        }

  @spec load(String.t()) :: {:error, any} | {:ok, Brunel.Dataset.t()}
  def load(filename) do
    with {:ok, handle} <- Utils.Zip.load(filename) do
      # TODO: Do this with Tasks (in parallel)
      # TODO: Make Resource a macro (each load function does the same thing)
      dataset =
        %Brunel.Dataset{source: handle}
        |> Agency.load()
        |> Stop.load()
        |> StopTime.load()
        |> Trip.load()

      {:ok, dataset}
    end
  end
end
