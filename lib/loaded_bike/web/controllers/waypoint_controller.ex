defmodule LoadedBike.Web.WaypointController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{Tour, Waypoint, Photo}

  def show(conn, %{"tour_id" => tour_id, "id" => id}) do
    waypoints_query = Waypoint
      |> Waypoint.published

    tour = Tour
      |> Tour.published
      |> preload(waypoints: ^waypoints_query)
      |> Repo.get!(tour_id)

    photos_query = Photo
      |> order_by(asc: :inserted_at)

    waypoint = assoc(tour, :waypoints)
      |> Waypoint.published
      |> preload(photos: ^photos_query)
      |> Repo.get!(id)

    prev_waypoint = Waypoint
      |> Waypoint.published
      |> where([w], w.position < ^waypoint.position)
      |> order_by(desc: :position)
      |> limit(1)
      |> Repo.one

    next_waypoint = Waypoint
      |> Waypoint.published
      |> where([w], w.position > ^waypoint.position)
      |> order_by(asc: :position)
      |> limit(1)
      |> Repo.one

    conn
    |> render("show.html",
        tour:           tour,
        waypoint:       waypoint,
        next_waypoint:  next_waypoint,
        prev_waypoint:  prev_waypoint)
  end
end
