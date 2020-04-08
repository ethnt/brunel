defmodule Brunel.Route do
  @moduledoc """
  Represents route data.
  """

  @behaviour Brunel.Resource

  alias Brunel.{Route, Utils}

  use Memento.Table,
    attributes: [:route_id, :agency_id, :route_short_name, :route_long_name],
    type: :ordered_set

  @type t :: %__MODULE__{
          __meta__: Memento.Table,
          route_id: integer,
          agency_id: integer,
          route_short_name: String.t() | nil,
          route_long_name: String.t() | nil
        }

  @impl Brunel.Resource
  @spec load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def load(%{source: source} = dataset) do
    routes =
      with {:ok, file} = Utils.Zip.get("routes.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.cast_values(:route_id, :integer)
        |> Utils.cast_values(:agency_id, :integer)
        |> Utils.recursive_struct(Route)
        |> Utils.Persistence.bulk_write()
      end

    %{dataset | routes: routes}
  end

  @impl Brunel.Resource
  @spec find(integer) :: Route.t() | nil
  def find(id) do
    Utils.Persistence.find_by(Route, :route_id, id)
  end
end
