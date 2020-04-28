defmodule Brunel.GTFS.Dataset do
  @moduledoc """
  A set of GTFS data.
  """

  defstruct ~w(source agencies services stops stop_times trips)a

  alias Brunel.Utils
  alias Brunel.GTFS.{Agency, Dataset, Service, Stop, StopTime, Trip}

  @typedoc """
  Represents a complete Brunel dataset.
  """
  @type t :: %__MODULE__{
          source: :zip.handle(),
          agencies: list(Agency.t()) | nil,
          services: list(Service.t()) | nil,
          stops: list(Stop.t()) | nil,
          stop_times: list(StopTime.t()) | nil,
          trips: list(Trip.t()) | nil
        }

  @spec load(String.t()) :: {:error, any} | {:ok, Dataset.t()}
  def load(filename) do
    with {:ok, handle} <- Utils.Zip.load(filename) do
      dataset =
        %Dataset{source: handle}
        |> Agency.load()
        |> Service.load()
        |> Stop.load()
        |> StopTime.load()
        |> Trip.load()

      {:ok, dataset}
    end
  end
end
