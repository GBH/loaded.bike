defmodule PedalApp.Web.PageControllerTest do
  use PedalApp.Web.ConnCase

  test "show", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello"
  end
end
