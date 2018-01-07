defmodule LoadedBike.Web.WaypointController do
  use LoadedBike.Web, :controller
  use LoadedBike.Web.Controller.Helpers

  alias LoadedBike.{Tour, Waypoint, Photo}

  def show(conn, %{"tour_id" => tour_id, "id" => id}) do
    waypoints_query = Waypoint
      |> Waypoint.published
      |> Waypoint.select_without_gps
      |> order_by(asc: :position)

    tour = Tour
      |> Tour.published
      |> preload([:user, waypoints: ^waypoints_query])
      |> Repo.get!(id_from_param(tour_id))

    photos_query = Photo
      |> order_by(asc: :inserted_at)

    waypoint = assoc(tour, :waypoints)
      |> Waypoint.published
      |> preload(photos: ^photos_query)
      |> Repo.get!(id_from_param(id))
      |> Map.put(:tour, tour)

    prev_waypoint = waypoint
      |> Waypoint.previous
      |> Waypoint.published
      |> Repo.one

    next_waypoint = waypoint
      |> Waypoint.next
      |> Waypoint.published
      |> Repo.one

    conn
    |> add_breadcrumb(name: "All Tours", url: tour_path(conn, :index))
    |> add_breadcrumb(name: tour.title, url: tour_path(conn, :show, tour))
    |> add_breadcrumb(name: waypoint.title)
    |> add_header_title(tour.title)
    |> add_header_title(waypoint.title)
    |> render("show.html",
        tour:           tour,
        waypoint:       waypoint,
        next_waypoint:  next_waypoint,
        prev_waypoint:  prev_waypoint)
  end
end
