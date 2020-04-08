defmodule Brunel.Dataset do
  @moduledoc """
  A set of GTFS data.
  """

  defstruct ~w(source agencies routes trips)a

  alias Brunel.{Agency, Route, Trip, Utils}

  @typedoc """
  Represents a complete Brunel dataset.
  """
  @type t :: %__MODULE__{
          source: :zip.handle(),
          agencies: list(Agency.t()) | nil,
          routes: list(Route.t()) | nil,
          trips: list(Trip.t()) | nil
        }

  @spec load(String.t()) :: {:error, any} | {:ok, Brunel.Dataset.t()}
  def load(filename) do
    Utils.Persistence.prepare()

    with {:ok, handle} <- Utils.Zip.load(filename) do
      dataset =
        %Brunel.Dataset{source: handle}
        |> Agency.load()
        |> Route.load()
        |> Trip.load()

      {:ok, dataset}
    end
  end
end
