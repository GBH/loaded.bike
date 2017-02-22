defmodule PedalApp.UserControllerTest do
  use PedalApp.ConnCase

  import PedalApp.TestFactory

  test "new" do
    conn = get build_conn(), "/rider/new"
    assert response(conn, 200)
    assert assigns(conn, :changeset)
    assert_template conn, "new.html"
  end

  test "show" do
    user = insert(:user)
    conn = get build_conn(), "/riders/#{user.id}"
    assert response(conn, 200)
    assert assigns(conn, :user).__struct__ == PedalApp.User
    assert_template conn, "show.html"
  end

  test "show not found" do
    assert_error_sent 400, fn ->
      build_conn() |> get("/riders/invalid")
    end
  end

  test "creation" do
    flunk
  end

  test "creation with error" do
    flunk
  end
end