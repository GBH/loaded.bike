defmodule LoadedBike.Waypoint do
  use LoadedBike.Web, :model

  # is_current, is_previous, url are virtual attrs we populate on the view
  @derive {Poison.Encoder, only: [:title, :lat, :lng, :is_current, :is_previous, :is_finish, :url]}

  schema "waypoints" do
    field :title,         :string
    field :description,   :string
    field :lat,           :float
    field :lng,           :float
    field :position,      :integer
    field :geojson,       :map
    field :gpx_file,      :any, virtual: true
    field :is_published,  :boolean

    belongs_to :tour, LoadedBike.Tour

    has_many :photos, LoadedBike.Photo

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :lat, :lng, :position, :gpx_file, :is_published])
    |> set_position
    |> process_gpx_file
    |> set_location
    |> assoc_constraint(:tour)
    |> validate_required([:tour_id, :title, :lat, :lng])
    |> validate_number(:lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:lng, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
  end

  defp process_gpx_file(changeset) do
    gpx_file = get_change(changeset, :gpx_file)

    if gpx_file && get_field(changeset, :position) != 0 do
      case LoadedBike.Lib.GPX2GeoJSON.convert(gpx_file) do
        {:ok,   %{coordinates: []}} -> add_error(changeset, :gpx_file, ".gpx file doesn't contain track data")
        {:ok,    geojson}           -> change(changeset, geojson: geojson)
        {:error, message}           -> add_error(changeset, :gpx_file, message)
      end
    else
      changeset
    end
  end

  # If we're creating a new waypoint with provided .gpx file, let's use that
  # instead of manual dropped pin. Always correctable via editing later.
  defp set_location(changeset) do
    state   = Ecto.get_meta(changeset.data, :state)
    geojson = get_change(changeset, :geojson)
    case {state, geojson}  do
      {:built, geojson} when geojson != nil ->
        [lng, lat | _] = List.last(geojson[:coordinates])
        change(changeset, lat: lat, lng: lng)

      _ ->
        changeset
    end
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
    where(query, [w], w.is_published == true)
  end

  # during association preloads we don't want to load geojson data for every waypoint
  def select_without_gps(query) do
    select(query, [:id, :tour_id, :title, :position, :lat, :lng, :is_published])
  end

  def previous(waypoint) do
    __MODULE__
    |> select([:id, :title])
    |> where([w], w.position < ^waypoint.position)
    |> where([w], w.tour_id == ^waypoint.tour_id)
    |> order_by(desc: :position)
    |> limit(1)
  end

  def next(waypoint) do
    __MODULE__
    |> select([:id, :title])
    |> where([w], w.position > ^waypoint.position)
    |> where([w], w.tour_id == ^waypoint.tour_id)
    |> order_by(asc: :position)
    |> limit(1)
  end
end