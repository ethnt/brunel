defmodule Brunel.Repo.Migrations.CreateRoutes do
  use Ecto.Migration

  # route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color
  def change do
    create table("routes", primary_key: false) do
      add :route_id, :integer, primary_key: true
      add :agency_id, references(:agencies, column: :agency_id)
      add :route_short_name, :string
      add :route_long_name, :string
      add :route_desc, :string
      add :route_type, :string
      add :route_url, :string
      add :route_color, :string
      add :route_text_color, :string
    end
  end
end
