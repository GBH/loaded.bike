defmodule LoadedBike.Web.LandingController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{Tour, Waypoint}

  def show(conn, _params) do
    tours = Tour
      |> Tour.published
      |> order_by(desc: :inserted_at)
      |> preload([:user, waypoints: ^Waypoint.published(Waypoint)])
      |> limit(3)
      |> Repo.all

    render(conn, "show.html", tours: tours)
  end
end
