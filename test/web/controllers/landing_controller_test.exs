defmodule LoadedBike.Web.PageControllerTest do
  use LoadedBike.Web.ConnCase

  test "show", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello"
  end
end
