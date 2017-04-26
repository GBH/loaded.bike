defmodule LoadedBike.Web.LayoutViewTest do
  use LoadedBike.Web.ConnCase, async: true

  alias LoadedBike.Web.LayoutView

  test "page_identifier" do
    conn = get build_conn(), "/"
    assert LayoutView.page_identifier(conn) == "LandingShowView"
  end

  test "header_title", %{conn: conn} do
    assert LayoutView.header_title(conn) == "Loaded Bike - Bicycle Touring Routes"

    conn = %{conn | assigns: Map.put(conn.assigns, :header_titles, ["a", "b"])}
    assert LayoutView.header_title(conn) == "Loaded Bike - a - b"
  end
end
