defmodule LoadedBike.Repo.Migrations.AddingTourStatus do
  use Ecto.Migration

  def change do
    alter table(:tours) do
      add :status, :integer, null: false, default: 0
    end
    flush()

    execute "UPDATE tours SET status = 2 WHERE is_completed = true"

    alter table(:tours) do
      remove :is_completed
    end

    create index(:tours, [:status])
  end
end
