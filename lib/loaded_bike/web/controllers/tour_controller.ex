defmodule LoadedBike.Web.TourController do
  use LoadedBike.Web, :controller

  alias LoadedBike.Tour

  def index(conn, _) do
    tours = Repo.all(from t in Tour, preload: [:waypoints])
    render(conn, "index.html", tours: tours)
  end

  def show(conn, %{"id" => id}) do
    tour = Repo.get!(Tour, id) |> Repo.preload(:waypoints)
    render(conn, "show.html", tour: tour)
  end
end