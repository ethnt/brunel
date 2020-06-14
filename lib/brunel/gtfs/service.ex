defmodule Brunel.GTFS.Service do
  @moduledoc """
  Represents calendars in GTFS.
  """

  @behaviour Brunel.GTFS.Resource

  defstruct ~w(
    service_id
    days
    start_date
    end_date
    date_interval
  )a

  alias Brunel.Utils
  alias Brunel.GTFS.Service

  @typedoc """
  Represents a calendar in the dataset.
  """
  @type t :: %__MODULE__{
          service_id: String.t(),
          days: list(atom),
          start_date: Date.t(),
          end_date: Date.t(),
          date_interval: Calendar.DateTime.Interval.t()
        }

  @impl Brunel.GTFS.Resource
  @spec load(dataset :: Brunel.GTFS.Dataset.t()) :: Brunel.GTFS.Dataset.t()
  def load(%{source: source} = dataset) do
    services =
      with {:ok, file} = Utils.Zip.get("calendar.txt", source) do
        file
        |> Utils.CSV.parse()
        |> parse_days()
        |> Utils.cast_values(:start_date, :date)
        |> Utils.cast_values(:end_date, :date)
        |> Enum.map(fn %{start_date: start_date, end_date: end_date} = service ->
          Map.put(service, :date_interval, Utils.Timing.date_interval(start_date, end_date))
        end)
        |> Utils.recursive_struct(Service)
      end

    %{dataset | services: services}
  end

  def for_date(%{services: services}, date \\ Utils.Timing.today()) do
    day_of_week = Utils.Timing.day_of_week(date)

    services
    |> Enum.filter(fn service -> Enum.member?(service.days, day_of_week) end)
    |> Enum.filter(fn service -> Utils.Timing.date_in_interval?(service.date_interval, date) end)
  end

  @spec parse_days(list(map)) :: list(map)
  defp parse_days(services) when is_list(services) do
    services
    |> Enum.map(&parse_days/1)
  end

  @spec parse_days(map) :: map
  defp parse_days(service) do
    days =
      service
      |> Map.take([:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday])
      # Should be 1, but MNR uses 0 for days it services
      |> Enum.filter(fn {_, value} -> value == "0" end)
      |> Keyword.keys()

    service
    |> Map.take([:service_id, :start_date, :end_date])
    |> Map.put(:days, days)
  end
end
