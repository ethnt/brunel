defmodule Brunel.Stop do
  defstruct ~w(stop_id stop_code stop_name)a

  alias Brunel.{Stop, Utils}

  @type t :: %__MODULE__{
          stop_id: String.t(),
          stop_code: String.t(),
          stop_name: String.t()
        }

  @spec build(Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def build(%{source: source} = dataset) do
    stops =
      "stops.txt"
      |> Utils.csv_from_zip(source)
      |> Utils.recursive_struct(Stop)

    %{dataset | stops: stops}
  end

  @spec find(%{stops: list(t)}, String.t()) :: any
  def find(%{stops: stops}, stop_id) do
    Enum.find(stops, fn %{stop_id: id} -> id == stop_id end)
  end
end
