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
          end_date: Date.t()
        }

  @impl Brunel.GTFS.Resource
  @spec load(dataset :: Brunel.GTFS.Dataset.t()) :: Brunel.GTFS.Dataset.t()
  def load(%{source: source} = dataset) do
    services =
      with {:ok, file} = Utils.Zip.get("calendar.txt", source) do
        file
        |> Utils.CSV.parse()
        |> parse_days()
        |> Utils.cast_values(:start_date, :time)
        |> Utils.cast_values(:end_date, :time)
        |> Utils.recursive_struct(Service)
      end

    %{dataset | services: services}
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
      |> Enum.filter(fn {_, value} -> value == "1" end)
      |> Keyword.keys()

    service
    |> Map.take([:service_id, :start_date, :end_date])
    |> Map.put(:days, days)
  end
end
