defmodule LoadedBike.Web.PageControllerTest do
  use LoadedBike.Web.ConnCase

  test "show" do
    insert(:tour)
    conn = get build_conn(), "/"
    assert html_response(conn, 200)
    assert template(conn) == "show.html"
    assert length(assigns(conn, :tours)) == 1
  end

  test "show with unpublished tours" do
    insert(:tour, %{is_published: false})
    conn = get build_conn(), "/"
    assert html_response(conn, 200)
    assert length(assigns(conn, :tours)) == 0
  end
end
