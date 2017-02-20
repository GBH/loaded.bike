defmodule Pedal.Repo.Migrations.CreateTour do
  use Ecto.Migration

  def change do
    create table(:tours) do
      add :title,       :string, null: false
      add :description, :text
      add :rider_id,    references(:riders, on_delete: :delete_all)

      timestamps()
    end

    create index(:tours, [:rider_id])
  end
end
