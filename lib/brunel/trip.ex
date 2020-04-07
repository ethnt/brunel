defmodule Brunel.Trip do
  alias Brunel.Utils

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:trip_id, :integer, []}
  schema "trips" do
    field :service_id, :string
    field :trip_headsign, :string
    field :trip_short_name, :string
    field :direction_id, :string

    belongs_to :route, Brunel.Route, references: :route_id
  end

  def build(%{source: source} = dataset) do
    "trips.txt"
    |> Utils.Zip.get(source)
    |> Utils.CSV.parse()
    |> Enum.map(fn trip -> %{trip | trip_id: String.to_integer(trip[:trip_id])} end)
    |> Enum.map(fn trip -> %{trip | route_id: String.to_integer(trip[:route_id])} end)
    |> Enum.map(fn trip -> Brunel.Trip.changeset(%Brunel.Trip{}, trip) end)
    |> Enum.map(fn trip -> Brunel.Repo.insert(trip) end)

    dataset
  end

  def changeset(trip \\ %Brunel.Trip{}, params) do
    trip
    |> cast(params, [:trip_id, :service_id, :trip_headsign, :trip_short_name, :direction_id])
  end
end
