defmodule PedalApp.Web.LandingController do
  use PedalApp.Web, :controller

  def show(conn, _params) do
    render conn, "show.html"
  end
end
