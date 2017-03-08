defmodule PedalApp.Repo.Migrations.CreatePhoto do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :waypoint_id, references(:waypoints, on_delete: :nothing)

      add :file, :string
      add :description, :text
      add :position, :integer

      timestamps()
    end

    create index(:photos, [:waypoint_id])
  end
end

