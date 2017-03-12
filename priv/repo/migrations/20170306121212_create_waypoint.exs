defmodule PedalApp.Repo.Migrations.CreateWaypoint do
  use Ecto.Migration

  def change do
    create table(:waypoints) do
      add :tour_id,     references(:tours, on_delete: :delete_all), null: false

      add :title,       :string, null: false
      add :description, :text
      add :lat,         :float, null: false
      add :lng,         :float, null: false

      add :is_published, :boolean, null: false, default: false

      timestamps()
    end

    create index(:waypoints, [:tour_id])
    create index(:waypoints, [:is_published])
  end
end
