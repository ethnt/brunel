defmodule Brunel.Repo.Migrations.CreateStopTimes do
  use Ecto.Migration

  # trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type,drop_off_type,track,note_id
  def change do
    create table("stop_times", primary_key: false) do
      add :trip_id, references(:agencies, column: :trip_id, primary_key: true)
      add :stop_id, references(:stops, column: :stop_id, primary_key: true)
      add :arrival_time, :string
      add :departure_time, :string
    end
  end
end
