defmodule LoadedBike.Web.LandingController do
  use LoadedBike.Web, :controller

  def show(conn, _params) do
    render conn, "show.html"
  end
end
