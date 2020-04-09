defmodule Brunel.Repo.Migrations.CreateStops do
  use Ecto.Migration

  def change do
    create table("stops") do
      add :stop_id, :string
      add :stop_code, :string
      add :stop_name, :string
      add :stop_desc, :string
    end

    create index("stops", [:stop_id], unique: true)
  end
end
