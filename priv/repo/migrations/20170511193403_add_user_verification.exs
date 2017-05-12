defmodule LoadedBike.Repo.Migrations.AddUserVerification do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :verification_token, :string
    end
    create index(:users, [:verification_token])
  end
end
