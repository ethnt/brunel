defmodule Brunel.Agency do
  @moduledoc """
  Represents agency data.
  """

  use Ecto.Schema

  alias Brunel.{Agency, Utils}

  @primary_key {:agency_id, :integer, []}
  schema "agencies" do
    field :agency_name
    field :agency_url
    field :agency_timezone
    field :agency_phone
    field :agency_lang

    has_many :routes, Brunel.Route
  end

  def load(%{source: source} = dataset) do
    agencies =
      with {:ok, file} = Utils.Zip.get("agency.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.cast_values(:agency_id, :integer)
        |> Utils.recursive_struct(Agency)
      end

    %{dataset | agencies: agencies}
  end
end
