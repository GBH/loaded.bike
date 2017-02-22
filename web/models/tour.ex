defmodule PedalApp.Tour do
  use PedalApp.Web, :model

  schema "tours" do
    field :title,       :string
    field :description, :string

    belongs_to :user, PedalApp.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title])
    |> assoc_constraint(:user)
  end
end
