defmodule Brunel.Repo.Migrations.CreateTrips do
  use Ecto.Migration

  def change do
    create table("trips", primary_key: false) do
      add :trip_id, :integer, primary_key: true
      add :route_id, references(:routes, column: :route_id)
      add :service_id, :string
      add :trip_headsign, :string
      add :trip_short_name, :string
      add :direction_id, :string
    end
  end
end
