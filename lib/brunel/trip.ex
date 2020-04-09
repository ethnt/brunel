defmodule Brunel.Trip do
  @moduledoc """
  Represents trip data.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Brunel.{Trip, Utils}

  schema "trips" do
    field(:trip_id)
    field(:service_id)
    field(:trip_headsign)
    field(:trip_short_name)

    belongs_to(:route, Brunel.Route, references: :route_id, foreign_key: :route_id, type: :string)

    has_many(:stop_times, Brunel.StopTime, foreign_key: :trip_id, references: :trip_id)
    has_many(:stops, through: [:stop_times, :stop])
  end

  def load(%{source: source} = dataset) do
    with {:ok, file} = Utils.Zip.get("trips.txt", source) do
      file
      |> Utils.CSV.parse()
      |> Utils.recursive_changeset(Trip)
      |> Utils.build_multi()
      |> Brunel.Repo.transaction()
    end

    dataset
  end

  @spec changeset(%Trip{}, map) :: Ecto.Changeset.t()
  def changeset(stop, params \\ %{}) do
    stop
    |> cast(params, [:trip_id, :route_id, :service_id, :trip_headsign, :trip_short_name])
  end
end
