defmodule Brunel.Wayfinding.Timetable do
  @moduledoc """
  Represents a set of trips for a specific day.
  """

  alias Brunel.Utils
  alias Brunel.Wayfinding.Timetable

  defstruct ~w(date trips connections)a

  # def for_day(dataset, date \\ Utils.Timing.today()) do
  #   day_of_week = Utils.Timing.day_of_week(date)

  #   timetable = %Timetable{date: date}

  #   service_ids =
  #     dataset.services
  #     |> Enum.filter(fn service -> Enum.member?(service.days, day_of_week) end)
  #     |> Enum.map(fn service -> service.service_id end)

  #   trips =
  #     dataset.trips
  #     |> Enum.filter(fn trip -> Enum.member?(service_ids, trip.service_id) end)

  #   %{timetable | trips: trips}
  # end
end
