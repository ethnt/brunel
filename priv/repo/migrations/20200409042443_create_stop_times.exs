defmodule Brunel.Repo.Migrations.CreateStopTimes do
  use Ecto.Migration

  # trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type,drop_off_type,track,note_id
  def change do
    create table("stop_times") do
      add :trip_id, references("trips", column: :trip_id, type: :string)
      add :stop_id, references("stops", column: :stop_id, type: :string)
      add :arrival_time, :string
      add :departure_time, :string
      add :stop_sequence, :string
      add :track, :string
    end
  end
end
