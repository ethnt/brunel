defmodule Brunel.Repo.Migrations.CreateDatasets do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:dataset)
  end
end
