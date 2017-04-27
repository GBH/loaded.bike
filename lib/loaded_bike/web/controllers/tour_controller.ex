defmodule LoadedBike.Web.TourController do
  use LoadedBike.Web, :controller
  use LoadedBike.Web.Controller.Helpers

  alias LoadedBike.{Tour, Waypoint}

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
      |> Repo.get!(id)

    conn
    |> add_breadcrumb(name: "All Tours", url: tour_path(conn, :index))
    |> add_breadcrumb(name: tour.title)
    |> add_header_title(tour.title)
    |> render("show.html", tour: tour)
  end

  defp waypoints_query do
    Waypoint
    |> Waypoint.published
    |> Waypoint.select_without_gps
    |> order_by(asc: :position)
  end
end