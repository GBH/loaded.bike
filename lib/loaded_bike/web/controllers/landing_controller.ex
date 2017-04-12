defmodule LoadedBike.Web.LandingController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{Tour}

  def show(conn, _params) do
    tours = Repo.all(
      from t in Tour,
      order_by: [desc: t.inserted_at],
      where:    t.is_published == true,
      limit:    5
    )
    |> Repo.preload([:user, :waypoints])

    render conn, "show.html", tours: tours
  end
end
