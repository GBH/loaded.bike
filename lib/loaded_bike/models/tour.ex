defmodule LoadedBike.Tour do
  use LoadedBike.Web, :model

  alias LoadedBike.User

  schema "tours" do
    field :title,             :string
    field :short_description, :string
    field :description,       :string
    field :status,            TourStateEnum
    field :is_published,      :boolean

    belongs_to :user, LoadedBike.User

    has_many :waypoints, LoadedBike.Waypoint

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :short_description, :description, :status, :is_published])
    |> assoc_constraint(:user)
    |> changeset_for_is_published
    |> validate_required([:user_id, :title, :status])
  end

  def published(query) do
    where(query, [t], t.is_published == true)
  end

  def with_status(query, status) do
    where(query, [t], t.status == ^status)
  end

  defp changeset_for_is_published(changeset) do
    is_published = get_change(changeset, :is_published)
    user = Repo.get(User, changeset.data.user_id || 0)
    if !!is_published && user && user.verification_token != nil do
      changeset |> add_error(:is_published, "Unverified accounts cannot publish")
    else
      changeset
    end
  end
end
