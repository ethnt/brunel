defmodule Brunel.Stop do
  @moduledoc """
  Represents stop data.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Brunel.{Stop, Utils}

  schema "stops" do
    field(:stop_id)
    field(:stop_code)
    field(:stop_name)
    field(:stop_desc)

    belongs_to(:parent_stop, Brunel.Stop,
      references: :stop_id,
      foreign_key: :parent_station,
      type: :string
    )
  end

  def load(%{source: source} = dataset) do
    with {:ok, file} = Utils.Zip.get("stops.txt", source) do
      file
      |> Utils.CSV.parse()
      |> Utils.recursive_changeset(Stop)
      |> Utils.build_multi()
      |> Brunel.Repo.transaction()
    end

    dataset
  end

  @spec changeset(%Stop{}, map) :: Ecto.Changeset.t()
  def changeset(stop, params \\ %{}) do
    stop
    |> cast(params, [:stop_id, :stop_code, :stop_name, :parent_station])
  end
end
