defmodule LoadedBike.Web.TourController do
  use LoadedBike.Web, :controller
  use LoadedBike.Web.Controller.Helpers
  use Drab.Controller

  alias LoadedBike.{Tour, Waypoint, Photo}

  def index(conn, params) do
    {tours, paginator} = Tour
      |> Tour.published
      |> order_by(desc: :id)
      |> preload([:user, waypoints: ^waypoints_query()])
      |> Repo.paginate(params)

    conn
    |> render("index.html", tours: tours, paginator: paginator)
  end

  def show(conn, %{"id" => id}) do
    tour = Tour
      |> Tour.published
      |> preload([:user, waypoints: ^waypoints_query()])
      |> Repo.get!(id_from_param(id))

    photos_query = Photo
      |> order_by(asc: :inserted_at)

    waypoints = assoc(tour, :waypoints)
      |> Waypoint.published
      |> select([:id, :tour_id, :title, :description, :position, :is_planned])
      |> preload(photos: ^photos_query)
      |> order_by(asc: :position)
      |> limit(3)
      |> Repo.all

    conn
    |> add_breadcrumb(name: "All Tours", url: tour_path(conn, :index))
    |> add_breadcrumb(name: tour.title)
    |> add_header_title(tour.title)
    |> render("show.html",
        tour:             tour,
        waypoints:        waypoints,
        last_waypoint:    List.last(waypoints)
      )
  end

  defp waypoints_query do
    Waypoint
    |> Waypoint.published
    |> Waypoint.select_without_gps
    |> order_by(asc: :position)
  end
end
