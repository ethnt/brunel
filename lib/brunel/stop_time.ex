defmodule Brunel.StopTime do
  @moduledoc """
  Represents route data.
  """

  @behaviour Brunel.Resource

  alias Brunel.{StopTime, Utils}

  use Memento.Table,
    attributes: [:id, :stop_id, :trip_id, :arrival_time, :departure_time, :stop_sequence],
    type: :ordered_set,
    autoincrement: true

  @type t :: %__MODULE__{
          __meta__: Memento.Table,
          id: integer,
          stop_id: integer,
          trip_id: integer,
          arrival_time: String.t() | nil,
          departure_time: String.t() | nil,
          stop_sequence: String.t() | nil
        }

  @impl Brunel.Resource
  @spec load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def load(%{source: source} = dataset) do
    stop_times =
      with {:ok, file} = Utils.Zip.get("stop_times.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.cast_values(:stop_id, :integer)
        |> Utils.cast_values(:trip_id, :integer)
        |> Utils.recursive_struct(StopTime)
        |> Utils.Persistence.bulk_write()
      end

    %{dataset | stop_times: stop_times}
  end

  @impl Brunel.Resource
  @spec find(integer) :: StopTime.t() | nil
  def find(id) do
    Utils.Persistence.find_by(StopTime, :id, id)
  end
end
