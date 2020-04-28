defmodule Brunel.Wayfinding.Segment do
  @moduledoc """
  Represents segments in a trip between stops.
  """

  defstruct ~w(trip_id departing_stop_id arriving_stop_id departing_time arriving_time)a

  alias Brunel.Wayfinding.Segment

  @type t :: %__MODULE__{
          trip_id: String.t(),
          departing_stop_id: String.t(),
          arriving_stop_id: String.t(),
          departing_time: Time.t(),
          arriving_time: Time.t()
        }

  @spec load(Brunel.GTFS.Dataset.t()) :: list(Segment.t())
  def load(%{stop_times: stop_times}) do
    stop_times
    |> Enum.sort_by(&Map.fetch(&1, :stop_sequence))
    |> Enum.group_by(&Map.fetch(&1, :trip_id))
    |> Enum.map(fn {_, times} ->
      times
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [start, stop] ->
        %Segment{
          trip_id: start.trip_id,
          departing_stop_id: start.stop_id,
          arriving_stop_id: stop.stop_id,
          departing_time: start.departure_time,
          arriving_time: stop.arrival_time
        }
      end)
    end)
    |> List.flatten()
    |> Enum.sort_by(&Map.fetch(&1, :departing_time))
  end

  # chunked_stop_times = Enum.chunk_every(2, 1, :discard) |> Enum.map(fn [start, stop] -> %{departure_time: start.departure_time, arrival_time: stop.arrival_time} end)
end
