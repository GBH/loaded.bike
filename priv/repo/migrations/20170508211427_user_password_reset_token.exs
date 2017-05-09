defmodule LoadedBike.Repo.Migrations.UserPasswordResetToken do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_reset_token, :string
    end
    create index(:users, [:password_reset_token])
  end
end
