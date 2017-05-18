defmodule LoadedBike.Repo.Migrations.AddUserProfileFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :bio, :text
      add :twitter, :string
      add :instagram, :string
    end
  end
end
