defmodule PedalApp.User do
  use PedalApp.Web, :model

  schema "users" do
    field :email,         :string
    field :name,          :string
    field :password_hash, :string
    field :password,      :string, virtual: true

    has_many :tours, PedalApp.Tour

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name])
    |> validate_required([:email, :name])
    |> validate_format(:email, ~r/@/)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
