defmodule PedalApp.Repo.Migrations.CreateTour do
  use Ecto.Migration

  def change do
    create table(:tours) do
      add :title,       :string, null: false
      add :description, :text
      add :user_id,     references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tours, [:user_id])
  end
end
