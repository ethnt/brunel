defmodule Brunel.StopTime do
  @moduledoc """
  Represents stop data.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Brunel.{StopTime, Utils}

  schema "stop_times" do
    field(:arrival_time)
    field(:departure_time)
    field(:stop_sequence)
    field(:track)

    belongs_to(:trip, Brunel.Trip, references: :trip_id, foreign_key: :trip_id, type: :string)
    belongs_to(:stop, Brunel.Stop, references: :stop_id, foreign_key: :stop_id, type: :string)
  end

  def load(%{source: source} = dataset) do
    with {:ok, file} = Utils.Zip.get("stop_times.txt", source) do
      chunks =
        file
        |> Utils.CSV.parse()
        |> Utils.recursive_changeset(StopTime)
        |> Enum.chunk_every(200)

      chunks
      |> Enum.each(fn chunk -> chunk |> Utils.build_multi() |> Brunel.Repo.transaction() end)
    end

    dataset
  end

  def changeset(stop_time, params \\ %{}) do
    stop_time
    |> cast(params, [:trip_id, :stop_id, :arrival_time, :departure_time, :stop_sequence, :track])
  end
end
