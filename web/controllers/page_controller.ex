defmodule Pedal.PageController do
  use Pedal.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
