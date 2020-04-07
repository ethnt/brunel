defmodule Brunel.Route do
  alias Brunel.Utils

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:route_id, :integer, []}
  schema "routes" do
    field :route_short_name, :string
    field :route_long_name, :string
    field :route_desc, :string
    field :route_type, :string
    field :route_url, :string
    field :route_color, :string
    field :route_text_color, :string

    belongs_to :agency, Brunel.Agency, references: :agency_id
  end

  def build(%{source: source} = dataset) do
    routes =
      "routes.txt"
      |> Utils.Zip.get(source)
      |> Utils.CSV.parse()
      |> Enum.map(fn route -> %{route | route_id: String.to_integer(route[:route_id])} end)
      |> Enum.map(fn route -> %{route | agency_id: String.to_integer(route[:agency_id])} end)

    Brunel.Repo.insert_all(Brunel.Route, routes)

    dataset
  end
end
