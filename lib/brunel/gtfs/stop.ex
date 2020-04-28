defmodule Brunel.GTFS.Stop do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.GTFS.Resource

  defstruct ~w(stop_id stop_code stop_name stop_desc stop_lat stop_lon zone_id stop_url location_type parent_station)a

  alias Brunel.Utils
  alias Brunel.GTFS.Stop

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

  @impl Brunel.GTFS.Resource
  @spec load(dataset :: Brunel.GTFS.Dataset.t()) :: Brunel.GTFS.Dataset.t()
  def load(%{source: source} = dataset) do
    stops =
      with {:ok, file} = Utils.Zip.get("stops.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.recursive_struct(Stop)
      end

    %{dataset | stops: stops}
  end
end