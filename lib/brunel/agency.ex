defmodule Brunel.Agency do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.Resource

  alias Brunel.{Agency, Utils}

  use Memento.Table,
    attributes: [:agency_id, :agency_name],
    type: :ordered_set

  @type t :: %__MODULE__{
          __meta__: Memento.Table,
          agency_id: integer,
          agency_name: String.t()
        }

  @impl Brunel.Resource
  @spec load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def load(%{source: source} = dataset) do
    agencies =
      with {:ok, file} = Utils.Zip.get("agency.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.cast_values(:agency_id, :integer)
        |> Utils.recursive_struct(Agency)
        |> Utils.Persistence.bulk_write()
      end

    %{dataset | agencies: agencies}
  end

  @impl Brunel.Resource
  @spec find(integer) :: Agency.t() | nil
  def find(id) do
    Utils.Persistence.find_by(Agency, :agency_id, id)
  end
end
