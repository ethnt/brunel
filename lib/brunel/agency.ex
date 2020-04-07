defmodule Brunel.Agency do
  @moduledoc """
  Represents agency data.
  """

  alias Brunel.Utils

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:agency_id, :integer, []}
  schema "agencies" do
    field :agency_name
    field :agency_url
    field :agency_timezone
    field :agency_phone
    field :agency_lang

    has_many :routes, Brunel.Route
  end

  def build(%{source: source} = dataset) do
    agencies =
      "agency.txt"
      |> Utils.Zip.get(source)
      |> Utils.CSV.parse()
      |> Enum.map(fn agency -> Brunel.Agency.changeset(%Brunel.Agency{}, agency) end)
      |> Enum.map(fn agency -> agency.changes end)

    Brunel.Repo.insert_all(Brunel.Agency, agencies)

    dataset
  end

  def changeset(agency, params \\ %{}) do
    params = %{params | agency_id: String.to_integer(params[:agency_id])}

    agency
    |> cast(params, [:agency_id, :agency_name, :agency_url, :agency_timezone, :agency_phone, :agency_lang])
  end
end
