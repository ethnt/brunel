defmodule Brunel.Stop do
  @moduledoc """
  Represents route data.
  """

  @behaviour Brunel.Resource

  alias Brunel.{Stop, Utils}

  use Memento.Table,
    attributes: [:stop_id, :stop_code, :stop_name],
    type: :ordered_set

  @type t :: %__MODULE__{
          __meta__: Memento.Table,
          stop_id: integer,
          stop_code: String.t() | nil,
          stop_name: String.t() | nil
        }

  @impl Brunel.Resource
  @spec load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def load(%{source: source} = dataset) do
    stops =
      with {:ok, file} = Utils.Zip.get("stops.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.cast_values(:stop_id, :integer)
        |> Utils.recursive_struct(Stop)
        |> Utils.Persistence.bulk_write()
      end

    %{dataset | stops: stops}
  end

  @impl Brunel.Resource
  @spec find(integer) :: Stop.t() | nil
  def find(id) do
    Utils.Persistence.find_by(Stop, :stop_id, id)
  end
end
