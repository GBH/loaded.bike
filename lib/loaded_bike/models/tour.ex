defmodule LoadedBike.Tour do
  use LoadedBike.Web, :model

  schema "tours" do
    field :title,             :string
    field :short_description, :string
    field :description,       :string
    field :is_completed,      :boolean
    field :is_published,      :boolean

    belongs_to :user, LoadedBike.User

    has_many :waypoints, LoadedBike.Waypoint

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :short_description, :description, :is_completed, :is_published])
    |> assoc_constraint(:user)
    |> validate_required([:user_id, :title])
  end

  def published(query) do
    from t in query, where: t.is_published == true
  end
end
