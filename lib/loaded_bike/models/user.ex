defmodule LoadedBike.User do
  use LoadedBike.Web, :model
  use Arc.Ecto.Schema

  schema "users" do
    field :email,         :string
    field :name,          :string
    field :password_hash, :string
    field :password,      :string, virtual: true
    field :avatar,        LoadedBike.Web.AvatarUploader.Type

    has_many :tours, LoadedBike.Tour

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :password])
    |> cast_attachments(params, [:avatar])
    |> validate_required([:email, :name])
    |> validate_format(:email, ~r/@/)
    |> hash_password
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
