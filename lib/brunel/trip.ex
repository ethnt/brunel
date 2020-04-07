defmodule Brunel.Trip do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.Resource

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

  @impl Brunel.Resource
  @spec load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def load(%{source: source} = dataset) do
    trips =
      with {:ok, file} = Utils.Zip.get("trips.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.recursive_struct(Trip)
      end

    %{dataset | trips: trips}
  end
end
