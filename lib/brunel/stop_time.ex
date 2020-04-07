defmodule Brunel.StopTime do
  alias Brunel.Utils

  use Ecto.Schema

  import Ecto.Changeset

  # @primary_key {[:stop_id, :trip_id], :integer, []}
  schema "stop_times" do
    field :arrival_time
    field :departure_time

    belongs_to :stop, Brunel.Stop, references: :stop_id
    belongs_to :trip, Brunel.Trip, references: :trip_id
  end

  def build(%{source: source} = dataset) do
    "stop_times.txt"
    |> Utils.Zip.get(source)
    |> Utils.CSV.parse()
    |> Enum.map(fn stop_time -> %{stop_time | stop_id: String.to_integer(stop_time[:stop_id])} end)
    |> Enum.map(fn stop_time -> %{stop_time | trip_id: String.to_integer(stop_time[:trip_id])} end)
    |> Enum.map(fn stop_time -> Brunel.StopTime.changeset(%Brunel.StopTime{}, stop_time) end)
    |> Enum.map(fn stop_time -> Brunel.Repo.insert(stop_time) end)

    dataset
  end

  def changeset(stop_time \\ %Brunel.StopTime{}, params) do
    stop_time
    |> cast(params, [:stop_id, :trip_id, :arrival_time, :departure_time])
  end
end
