defmodule Brunel.Trip do
  @behaviour Brunel.Resource

  defstruct ~w(route_id service_id trip_id trip_headsign trip_short_name direction_id)a

  alias Brunel
  alias Brunel.{Trip, Stop, Utils}

  @type t :: %__MODULE__{
          route_id: String.t(),
          service_id: String.t(),
          trip_id: String.t(),
          trip_headsign: String.t(),
          trip_short_name: String.t(),
          direction_id: String.t()
        }

  @impl Brunel.Resource
  @spec build(Brunel.Dataset.t) :: Brunel.Dataset.t
  def build(%{source: source} = dataset) do
    trips =
      "trips.txt"
      |> Utils.csv_from_zip(source)
      |> Utils.recursive_struct(Trip)

    %{dataset | trips: trips}
  end

  @spec find(Brunel.Dataset.t(), String.t()) :: Brunel.Trip.t()
  def find(%{trips: trips}, trip_id) do
    Enum.find(trips, fn %{trip_id: id} -> id == trip_id end)
  end

  @spec stops(Brunel.Dataset.t(), String.t()) :: list(Brunel.StopTime.t())
  def stops(%{stops: stops, stop_times: stop_times}, trip_id) do
    stop_times
    |> Enum.filter(fn %{trip_id: id} -> id == trip_id end)
    |> Enum.map(fn time -> %{time | stop: Stop.find(%{stops: stops}, time.stop_id)} end)
  end
end
