defmodule Brunel.Stop do
  alias Brunel.Utils

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:stop_id, :integer, []}
  schema "stops" do
    field :stop_name, :string
  end

  def build(%{source: source} = dataset) do
    "stops.txt"
    |> Utils.Zip.get(source)
    |> Utils.CSV.parse()
    |> Enum.map(fn stop -> %{stop | stop_id: String.to_integer(stop[:stop_id])} end)
    |> Enum.map(fn stop -> Brunel.Stop.changeset(%Brunel.Stop{}, stop) end)
    |> Enum.map(fn stop -> Brunel.Repo.insert(stop) end)

    dataset
  end

  def changeset(stop \\ %Brunel.Stop{}, params) do
    stop
    |> cast(params, [:stop_id, :stop_name])
  end
end
