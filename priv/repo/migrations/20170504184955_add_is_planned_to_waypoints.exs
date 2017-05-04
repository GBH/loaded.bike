defmodule LoadedBike.Repo.Migrations.AddIsPlannedToWaypoints do
  use Ecto.Migration

  def change do
    alter table(:waypoints) do
      add :is_planned, :boolean, null: false, default: false
    end

    flush()

    execute "UPDATE waypoints SET is_planned = false"
  end
end
