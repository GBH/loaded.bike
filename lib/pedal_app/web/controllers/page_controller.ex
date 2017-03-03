defmodule PedalApp.Web.PageController do
  use PedalApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
