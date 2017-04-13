defmodule LoadedBike.Web.TourController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{Tour, Waypoint}

  def index(conn, params) do
    {tours, paginator} = Tour
      |> Tour.published
      |> order_by(desc: :id)
      |> Repo.paginate(params)

    conn
    |> render("index.html", tours: tours, paginator: paginator)
  end

  def show(conn, %{"id" => id}) do
    wp_query = Waypoint
      |> Waypoint.published
      |> order_by(asc: :position)

    tour = Tour
      |> Tour.published
      |> preload(waypoints: ^wp_query)
      |> Repo.get!(id)

    render(conn, "show.html", tour: tour)
  end
end