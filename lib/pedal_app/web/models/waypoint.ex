defmodule PedalApp.Waypoint do
  use PedalApp.Web, :model

  @derive {Poison.Encoder, only: [:title, :lat, :lng]}

  schema "waypoints" do
    field :title,         :string
    field :description,   :string
    field :lat,           :float
    field :lng,           :float
    field :position,      :integer
    field :is_published,  :boolean

    belongs_to :tour, PedalApp.Tour

    has_many :photos, PedalApp.Photo

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
        count = PedalApp.Repo.aggregate(q, :count, :id)
        put_change(changeset, :position, count)
      :loaded ->
        changeset
    end
  end
end