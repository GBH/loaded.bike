defmodule LoadedBike.Repo.Migrations.RemoveIsPlanned do
  use Ecto.Migration

  def change do
    alter table(:waypoints) do
      remove :is_planned
    end
  end
end
