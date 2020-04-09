defmodule Brunel.Repo.Migrations.CreateRoutes do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table("routes") do
      add :route_id, :string
      add :agency_id, references("agencies", column: :agency_id, type: :string)
      add :route_short_name, :string
      add :route_long_name, :string
    end

    create index("routes", [:route_id], unique: true)
  end
end
