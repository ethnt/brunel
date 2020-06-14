defmodule Brunel.GTFS.Trip do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.GTFS.Resource

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

  alias Brunel.Utils
  alias Brunel.GTFS.Trip

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

  @impl Brunel.GTFS.Resource
  @spec load(dataset :: Brunel.GTFS.Dataset.t()) :: Brunel.GTFS.Dataset.t()
  def load(%{source: source} = dataset) do
    trips =
      with {:ok, file} = Utils.Zip.get("trips.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.recursive_struct(Trip)
      end

    %{dataset | trips: trips}
  end

  def for_date(%{trips: trips} = dataset, date \\ Utils.Timing.today()) do
    current_services =
      Brunel.GTFS.Service.for_date(dataset, date) |> Enum.map(&Map.get(&1, :service_id))

    trips
    |> Enum.filter(fn %{service_id: service_id} -> Enum.member?(current_services, service_id) end)
  end
end
