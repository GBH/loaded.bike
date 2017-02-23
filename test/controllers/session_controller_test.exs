defmodule PedalApp.SessionControllerTest do
  use PedalApp.ConnCase

  test "new" do
    conn = get build_conn(), "/login"
    assert response(conn, 200)
    assert template(conn) == "new.html"
  end

  test "create" do
    user = insert(:user)
    conn = post build_conn(), "/login", session: %{
      email: "test@example.org", password: "password"
    }
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Welcome"

    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "create with bad credentials" do
    conn = post build_conn(), "/login", session: %{
      email: "test@example.org", password: "invalid"
    }
    assert response(conn, 200)
    assert get_flash(conn, :error) == "Invalid login credentials"
    assert template(conn) == "new.html"

    refute Guardian.Plug.current_resource(conn)
  end

  test "delete" do
    user = insert(:user)
    conn = login(user)

    IO.inspect Guardian.Plug.current_resource(conn)

    #assert redirected_to(conn) == "/"
    #assert get_flash(conn, :info) == ""
  end
end