defmodule LoadedBike.Web.UserControllerTest do
  use LoadedBike.Web.ConnCase

  test "new" do
    conn = get build_conn(), "/rider/new"
    assert response(conn, 200)
    assert assigns(conn, :changeset)
    assert template(conn) == "new.html"
  end

  test "show" do
    user = insert(:user)
    conn = get build_conn(), "/riders/#{user.id}"
    assert response(conn, 200)
    assert template(conn) == "show.html"
    assert assigns(conn, :user)
  end

  test "show not found" do
    assert_error_sent 404, fn ->
      get(build_conn(), "/riders/0")
    end
  end

  test "creation" do
    conn = post build_conn(), "/rider", user: %{
      email:    "test@test.test",
      name:     "Tester",
      password: "password"
    }

    rider = Repo.get_by(User, email: "test@test.test")
    assert rider
    assert redirected_to(conn) == "/riders/#{rider.id}"
  end

  test "creation with error" do
    conn = post build_conn(), "/rider", user: %{}
    assert response(conn, 200)
    assert template(conn) == "new.html"
  end
end