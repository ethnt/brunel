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
      dataset = build(handle)

      {:ok, dataset}
    end
  end

  @spec build(Utils.Zip.handle()) :: Brunel.Dataset.t()
  def build(handle) do
    %Brunel.Dataset{source: handle}
    |> Agency.build()
    |> Stop.build()
    |> StopTime.build()
    |> Trip.build()
  end
end
