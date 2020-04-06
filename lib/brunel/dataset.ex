defmodule Brunel.Dataset do
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
  def load(file) do
    with {:ok, handle} <- Utils.load_zip(file) do
      dataset = build(handle)

      {:ok, dataset}
    end
  end

  @spec build(Brunel.Utils.ZIP.zip_handle()) :: Brunel.Dataset.t
  def build(handle) do
    %Brunel.Dataset{source: handle}
    |> Agency.build()
    |> Stop.build()
    |> StopTime.build()
    |> Trip.build()
  end
end
