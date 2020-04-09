defmodule Brunel.Route do
  @moduledoc """
  Represents route data.
  """

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias Brunel.{Route, Utils}

  schema "routes" do
    field(:route_id)
    field(:route_short_name)
    field(:route_long_name)

    belongs_to(:agency, Brunel.Agency,
      references: :agency_id,
      foreign_key: :agency_id,
      type: :string
    )

    has_many(:trips, Brunel.Trip, foreign_key: :route_id, references: :route_id)
    has_many(:stop_times, through: [:trips, :stop_times])
    has_many(:stops, through: [:stop_times, :stop])
  end

  def load(%{source: source} = dataset) do
    with {:ok, file} = Utils.Zip.get("routes.txt", source) do
      file
      |> Utils.CSV.parse()
      |> Utils.recursive_changeset(Route)
      |> Utils.build_multi()
      |> Brunel.Repo.transaction()
    end

    dataset
  end

  @spec changeset(%Route{}, map) :: Ecto.Changeset.t()
  def changeset(route, params \\ %{}) do
    route
    |> cast(params, [:route_id, :agency_id, :route_short_name, :route_long_name])
  end

  def stops(route) do
    query =
      from(s in Brunel.Stop,
        distinct: true,
        join: st in Brunel.StopTime,
        on: st.stop_id == s.stop_id,
        join: t in Brunel.Trip,
        on: st.trip_id == t.trip_id,
        join: r in Brunel.Route,
        on: t.route_id == r.route_id,
        where: r.route_id == ^route.route_id
      )

    Brunel.Repo.all(query)
  end
end
