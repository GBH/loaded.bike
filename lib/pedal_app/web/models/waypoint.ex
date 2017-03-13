defmodule PedalApp.Waypoint do
  use PedalApp.Web, :model

  schema "waypoints" do
    field :title,       :string
    field :description, :string
    field :lat,         :float
    field :lng,         :float

    belongs_to :tour, PedalApp.Tour

    has_many :photos, PedalApp.Photo

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tour_id, :title, :description, :lat, :lng])
    |> validate_required([:tour_id, :title, :lat, :lng])
    |> validate_number(:lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:lng, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> assoc_constraint(:tour)
  end
end