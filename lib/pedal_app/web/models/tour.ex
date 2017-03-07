defmodule PedalApp.Tour do
  use PedalApp.Web, :model

  schema "tours" do
    field :title,       :string
    field :description, :string

    belongs_to :user, PedalApp.User

    has_many :waypoints, PedalApp.Waypoint

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :title, :description])
    |> validate_required([:user_id, :title])
    |> assoc_constraint(:user)
  end
end
