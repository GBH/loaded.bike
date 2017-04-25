defmodule LoadedBike.Repo.Migrations.CreatePhoto do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :waypoint_id, references(:waypoints, on_delete: :delete_all)

      add :file,        :string
      add :description, :text
      add :position,    :integer
      add :uuid,        :string, null: false

      timestamps()
    end

    create index(:photos, [:waypoint_id])
  end
end

