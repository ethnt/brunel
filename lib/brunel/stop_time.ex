defmodule Brunel.StopTime do
  defstruct ~w(trip_id arrival_time departure_time stop_id stop_sequence pickup_type drop_off_type track stop)a

  alias Brunel.{StopTime, Utils}

  @type t :: %__MODULE__{
          trip_id: String.t(),
          arrival_time: String.t(),
          departure_time: String.t(),
          stop_id: String.t(),
          stop_sequence: String.t(),
          pickup_type: String.t(),
          drop_off_type: String.t(),
          track: String.t(),
          stop: Brunel.Stop.t() | nil
        }

  def build(dataset) do
    stop_times =
      "stop_times.txt"
      |> Utils.csv_from_zip(dataset.source)
      |> Utils.recursive_struct(StopTime)

    %{dataset | stop_times: stop_times}
  end
end
