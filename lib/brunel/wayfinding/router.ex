defmodule Brunel.Wayfinding.Router do
  @moduledoc nil

  alias Brunel.Utils.Timing

  def earliest_arrival(dataset, stop_a, stop_b) do
  end

  def trips_after_for_stop(%{stop_times: stop_times, trips: trips}, stop, time \\ Timing.now()) do
    trip_ids =
      stop_times
      |> Enum.filter(fn %{stop_id: stop_id, departure_time: departure_time} ->
        stop_id == stop.stop_id && Calendar.Time.diff(departure_time, time) > 0
      end)
      |> Enum.map(fn %{trip_id: trip_id} -> trip_id end)

    trips
    |> Enum.filter(fn %{trip_id: trip_id} -> Enum.member?(trip_ids, trip_id) end)
  end
end
