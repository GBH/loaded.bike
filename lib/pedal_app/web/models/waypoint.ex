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
    |> assoc_constraint(:tour)
  end
end