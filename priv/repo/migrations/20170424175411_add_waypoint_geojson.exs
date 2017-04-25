defmodule LoadedBike.Repo.Migrations.AddWaypointGeojson do
  use Ecto.Migration

  def change do
    alter table(:waypoints) do
      add :geojson, :map
    end
  end
end
