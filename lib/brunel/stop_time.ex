defmodule Brunel.StopTime do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.Resource

  defstruct ~w(
    trip_id
    arrival_time
    departure_time
    stop_id
    stop_sequence
    stop_headsign
    pickup_type
    drop_off_type
    shape_dist_traveled
    timepoint
  )a

  alias Brunel.{StopTime, Utils}

  @typedoc """
  Represents an agency in the dataset.
  """
  @type t :: %__MODULE__{
          trip_id: String.t(),
          arrival_time: String.t(),
          departure_time: String.t(),
          stop_id: String.t(),
          stop_sequence: String.t(),
          stop_headsign: String.t(),
          pickup_type: String.t(),
          drop_off_type: String.t(),
          shape_dist_traveled: String.t(),
          timepoint: String.t()
        }

  @impl Brunel.Resource
  @spec load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def load(%{source: source} = dataset) do
    stop_times =
      with {:ok, file} = Utils.Zip.get("stop_times.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.recursive_struct(StopTime)
      end

    %{dataset | stop_times: stop_times}
  end
end
