defmodule Brunel.Repo.Migrations.CreateStops do
  use Ecto.Migration

  # stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station,wheelchair_boarding
  def change do
    create table("stops", primary_key: false) do
      add :stop_id, :integer, primary_key: true
      add :stop_name, :string
    end
  end
end
