defmodule Brunel.Trip do
  @moduledoc """
  Represents agency data.
  """

  defstruct ~w(
    route_id
    service_id
    trip_id
    trip_headsign
    trip_short_name
    direction_id
    wheelchair_accessible
    bikes_allowed
  )a

  alias Brunel.{Trip, Utils}

  @typedoc """
  Represents an agency in the dataset.
  """
  @type t :: %__MODULE__{
          route_id: String.t(),
          service_id: String.t(),
          trip_id: String.t(),
          trip_headsign: String.t(),
          trip_short_name: String.t(),
          direction_id: String.t(),
          wheelchair_accessible: String.t(),
          bikes_allowed: String.t()
        }

  @spec build(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def build(%{source: source} = dataset) do
    trips =
      "trips.txt"
      |> Utils.Zip.get(source)
      |> Utils.CSV.parse()
      |> Utils.recursive_struct(Trip)

    %{dataset | trips: trips}
  end
end
