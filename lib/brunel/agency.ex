defmodule Brunel.Agency do
  @moduledoc """
  Represents agency data.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Brunel.{Agency, Utils}

  @primary_key {:agency_id, :integer, []}
  schema "agencies" do
    field :agency_name
    field :agency_url
    field :agency_timezone
    field :agency_phone
    field :agency_lang
  end

  def load(%{source: source} = dataset) do
    with {:ok, file} = Utils.Zip.get("agency.txt", source) do
      file
      |> Utils.CSV.parse()
      |> Utils.cast_values(:agency_id, :integer)
      |> Utils.recursive_changeset(Agency)
      |> Enum.map(fn %{changes: params} -> params end)
      |> Enum.chunk_every(900)
      |> Enum.each(fn group -> Brunel.Repo.insert_all(Brunel.Agency, group, on_conflict: :nothing) end)
    end

    dataset
  end

  @spec changeset(%Agency{}, map) :: Ecto.Changeset.t()
  def changeset(agency, params \\ %{}) do
    agency
    |> cast(params, [:agency_id, :agency_name, :agency_url, :agency_timezone, :agency_phone, :agency_lang])
  end
end
