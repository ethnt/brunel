defmodule Brunel.Repo.Migrations.CreateAgencies do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table("agencies") do
      add :agency_id, :string
      add :agency_name, :string
      add :agency_url, :string
      add :agency_timezone, :string
      add :agency_phone, :string
      add :agency_lang, :string
    end

    create index("agencies", [:agency_id], unique: true)
  end
end
