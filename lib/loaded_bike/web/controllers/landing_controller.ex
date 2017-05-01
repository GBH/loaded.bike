defmodule LoadedBike.Web.LandingController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{Tour, Waypoint}

  def show(conn, _params) do
    waypoints_query = Waypoint
      |> Waypoint.published
      |> Waypoint.select_without_gps
      |> order_by(asc: :position)

    tours = Tour
      |> Tour.published
      |> Tour.completed
      |> order_by(desc: :inserted_at)
      |> preload([:user, waypoints: ^waypoints_query])
      |> limit(3)
      |> Repo.all

    render(conn, "show.html", tours: tours)
  end
end
