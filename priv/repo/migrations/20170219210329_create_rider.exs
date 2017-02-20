defmodule Pedal.Repo.Migrations.CreateRider do
  use Ecto.Migration

  def change do
    create table(:riders) do
      add :email,         :string, null: false
      add :name,          :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index :riders, [:email]
  end
end
