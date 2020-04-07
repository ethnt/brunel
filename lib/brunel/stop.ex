defmodule Brunel.Stop do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.Resource

  defstruct ~w(stop_id stop_code stop_name stop_desc stop_lat stop_lon zone_id stop_url location_type parent_station)a

  alias Brunel.{Stop, Utils}

  @typedoc """
  Represents an agency in the dataset.
  """
  @type t :: %__MODULE__{
          stop_id: String.t(),
          stop_code: String.t(),
          stop_name: String.t(),
          stop_desc: String.t(),
          stop_lat: String.t(),
          stop_lon: String.t(),
          zone_id: String.t(),
          stop_url: String.t(),
          location_type: String.t(),
          parent_station: String.t()
        }

  @impl Brunel.Resource
  @spec build(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def build(%{source: source} = dataset) do
    stops =
      "stops.txt"
      |> Utils.Zip.get(source)
      |> Utils.CSV.parse()
      |> Utils.recursive_struct(Stop)

    %{dataset | stops: stops}
  end
end
