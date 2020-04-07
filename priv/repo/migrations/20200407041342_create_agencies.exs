defmodule Brunel.Repo.Migrations.CreateAgencies do
  use Ecto.Migration

  def change do
    create table("agencies", primary_key: false) do
      add :agency_id, :integer, primary_key: true
      add :agency_name, :string
      add :agency_url, :string
      add :agency_timezone, :string
      add :agency_phone, :string
      add :agency_lang, :string
    end
  end
end
