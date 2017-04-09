defmodule LoadedBike.Web.LayoutViewTest do
  use LoadedBike.Web.ConnCase, async: true

  alias LoadedBike.Web.LayoutView

  test "page_identifier" do
    conn = get build_conn(), "/"
    assert LayoutView.page_identifier(conn) == "LandingShowView"
  end
end
