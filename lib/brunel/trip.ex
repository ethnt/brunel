defmodule Brunel.Trip do
  @moduledoc """
  Represents route data.
  """

  @behaviour Brunel.Resource

  alias Brunel.{Trip, Utils}

  use Memento.Table,
    attributes: [:trip_id, :route_id, :service_id, :trip_headsign, :trip_short_name],
    type: :ordered_set

  @type t :: %__MODULE__{
          __meta__: Memento.Table,
          trip_id: integer,
          route_id: integer,
          service_id: integer,
          trip_headsign: String.t() | nil,
          trip_short_name: String.t() | nil
        }

  @impl Brunel.Resource
  @spec load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def load(%{source: source} = dataset) do
    trips =
      with {:ok, file} = Utils.Zip.get("trips.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.cast_values(:trip_id, :integer)
        |> Utils.cast_values(:route_id, :integer)
        |> Utils.cast_values(:service_id, :integer)
        |> Utils.recursive_struct(Trip)
        |> Utils.Persistence.bulk_write()
      end

    %{dataset | trips: trips}
  end

  @spec find(integer) :: Trip.t() | nil
  def find(id) do
    Utils.Persistence.find_by(Trip, :trip_id, id)
  end
end
