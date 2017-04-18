defmodule LoadedBike.Waypoint do
  use LoadedBike.Web, :model

  # is_current, is_previous, url are virtual attrs we populate on the view
  @derive {Poison.Encoder, only: [:title, :lat, :lng, :is_current, :is_previous, :url]}

  schema "waypoints" do
    field :title,         :string
    field :description,   :string
    field :lat,           :float
    field :lng,           :float
    field :position,      :integer
    field :is_published,  :boolean

    belongs_to :tour, LoadedBike.Tour

    has_many :photos, LoadedBike.Photo

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tour_id, :title, :description, :lat, :lng, :position, :is_published])
    |> set_position
    |> validate_required([:tour_id, :title, :lat, :lng])
    |> validate_number(:lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:lng, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> assoc_constraint(:tour)
  end

  defp set_position(changeset) do
    case Ecto.get_meta(changeset.data, :state) do
      :built ->
        tour_id = get_field(changeset, :tour_id)
        q = from __MODULE__, where: [tour_id: ^tour_id]
        count = LoadedBike.Repo.aggregate(q, :count, :id)
        put_change(changeset, :position, count)
      :loaded ->
        changeset
    end
  end

  def published(query) do
    query
    |> where([w], w.is_published == true)
  end

  def previous(waypoint) do
    __MODULE__
    |> select([:id])
    |> where([w], w.position < ^waypoint.position)
    |> where([w], w.tour_id == ^waypoint.tour_id)
    |> order_by(desc: :position)
    |> limit(1)
  end

  def next(waypoint) do
    __MODULE__
    |> select([:id])
    |> where([w], w.position > ^waypoint.position)
    |> where([w], w.tour_id == ^waypoint.tour_id)
    |> order_by(asc: :position)
    |> limit(1)
  end
end
