defmodule LoadedBike.Web.TourController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{Tour, Waypoint}

  def index(conn, _) do
    tours = Tour
      |> Tour.published
      |> Repo.all

    conn
    |> render("index.html", tours: tours)
  end

  def show(conn, %{"id" => id}) do
    tour = Tour
      |> Tour.published
      |> preload(waypoints: ^Waypoint.published(Waypoint))
      |> Repo.get!(id)

    render(conn, "show.html", tour: tour)
  end
end