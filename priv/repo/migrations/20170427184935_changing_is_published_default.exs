defmodule LoadedBike.Repo.Migrations.ChangingIsPublishedDefault do
  use Ecto.Migration

  def change do
    alter table(:tours) do
      modify :is_published, :boolean, null: false, default: true
    end

    alter table(:waypoints) do
      modify :is_published, :boolean, null: false, default: true
    end
  end
end
