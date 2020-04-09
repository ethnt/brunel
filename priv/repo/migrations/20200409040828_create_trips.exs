defmodule Brunel.Repo.Migrations.CreateTrips do
  use Ecto.Migration

  # route_id,service_id,trip_id,trip_headsign,trip_short_name,direction_id,block_id,shape_id,wheelchair_accessible,peak_offpeak
  def change do
    create table("trips") do
      add :trip_id, :string
      add :route_id, references("routes", column: :route_id, type: :string)
      add :service_id, :string
      add :trip_headsign, :string
      add :trip_short_name, :string
    end

    create index("trips", [:trip_id], unique: true)
  end
end
