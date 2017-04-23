defmodule LoadedBike.Web.SessionControllerTest do
  use LoadedBike.Web.ConnCase

  test "new" do
    conn = get build_conn(), "/signin"
    assert response(conn, 200)
    assert template(conn) == "new.html"
  end

  test "create" do
    user = insert(:user)
    conn = post build_conn(), "/signin", session: %{
      email: "test@example.org", password: "password"
    }
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Welcome back"

    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "create with bad credentials" do
    conn = post build_conn(), "/signin", session: %{
      email: "test@example.org", password: "invalid"
    }
    assert response(conn, 200)
    assert get_flash(conn, :error) == "Invalid login credentials"
    assert template(conn) == "new.html"

    refute Guardian.Plug.current_resource(conn)
  end

  test "create with blank credentials" do
    conn = post build_conn(), "/signin", session: %{
      email: "", password: ""
    }
    assert response(conn, 200)
    assert get_flash(conn, :error) == "Invalid login credentials"
    assert template(conn) == "new.html"

    refute Guardian.Plug.current_resource(conn)
  end

  test "delete" do
    user = insert(:user)
    conn = login(user)

    assert Guardian.Plug.current_resource(conn).id == user.id

    conn = delete conn, "/signout"
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Signed out"

    refute Guardian.Plug.current_resource(conn)
  end
end
