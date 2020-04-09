defmodule Brunel.Repo.Migrations.AddParentStationToStops do
  use Ecto.Migration

  def change do
    alter table("stops") do
      add :parent_station, references("stops", column: :stop_id, type: :string)
    end
  end
end
