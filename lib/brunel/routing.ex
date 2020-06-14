defmodule Brunel.Routing do
  alias Brunel.Utils
  alias Brunel.Routing.Journey

  @spec route(Brunel.GTFS.Dataset.t(), Brunel.GTFS.Stop.t(), Brunel.GTFS.Stop.t(), Time.t()) ::
          list(Brunel.GTFS.Trip.t())
  def route(dataset, stop_a, stop_b, departure_time \\ Utils.Timing.now()) do
    time = Utils.Timing.datetime_in_seconds_of_day(departure_time)

    departures_after_time =
      dataset.stop_times
      |> Enum.sort_by(&Map.get(&1, :departure_time))
      |> Enum.filter(fn st -> st.stop_id == stop_a.stop_id && st.departure_time > time end)
      |> Enum.take(20)
      |> Enum.map(&Map.get(&1, :trip_id))

    arrivals_after_time =
      dataset.stop_times
      |> Enum.sort_by(&Map.get(&1, :arrival_time))
      |> Enum.filter(fn st -> st.stop_id == stop_b.stop_id && st.arrival_time > time end)
      |> Enum.map(&Map.get(&1, :trip_id))

    MapSet.intersection(MapSet.new(departures_after_time), MapSet.new(arrivals_after_time))
    |> MapSet.to_list()
    |> Enum.map(fn trip_id ->
      trip = Enum.find(dataset.trips, fn trip -> trip.trip_id == trip_id end)

      departure_stop_time =
        dataset.stop_times
        |> Enum.find(fn st -> st.stop_id == stop_a.stop_id && st.trip_id == trip_id end)

      arrival_stop_time =
        dataset.stop_times
        |> Enum.find(fn st -> st.stop_id == stop_b.stop_id && st.trip_id == trip_id end)

      %Brunel.Routing.Journey{
        trip: trip,
        origin: stop_a.stop_name,
        destination: stop_b.stop_name,
        departure_time: departure_stop_time.departure_time |> Utils.Timing.seconds_to_time(),
        arrival_time: arrival_stop_time.arrival_time |> Utils.Timing.seconds_to_time()
      }
    end)
    |> Enum.uniq_by(fn journey -> journey.trip.trip_short_name end)
  end
end
