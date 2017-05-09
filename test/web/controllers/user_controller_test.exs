defmodule LoadedBike.Web.UserControllerTest do
  use LoadedBike.Web.ConnCase

  import LoadedBike.Web.Test.BuildUpload

  test "new" do
    conn = get build_conn(), "/rider/new"
    assert response(conn, 200)
    assert assigns(conn, :changeset)
    assert template(conn) == "new.html"
  end

  test "show" do
    user = insert(:user)
    tour = insert(:tour, %{user: user})
    insert(:waypoint, %{tour: tour})

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

  test "index" do
    conn = get build_conn(), "/riders"
    assert response(conn, 200)
    assert template(conn) == "index.html"
    assert assigns(conn, :users)
  end

  test "creation" do
    conn = post build_conn(), "/rider", user: %{
      email:    "test@test.test",
      name:     "Tester",
      password: "password"
    }

    user = Repo.get_by(User, email: "test@test.test")
    assert user
    assert redirected_to(conn) == "/"
  end

  test "creation with error" do
    conn = post build_conn(), "/rider", user: %{}
    assert response(conn, 200)
    assert template(conn) == "new.html"
  end

  test "edit" do
    user = insert(:user)
    conn = get login(user), "/rider/edit"
    assert response(conn, 200)
    assert template(conn) == "edit.html"
  end

  test "edit if not signed in" do
    conn = get build_conn(), "/rider/edit"
    assert redirected_to(conn) == "/signin"
    assert get_flash(conn, :error) == "You must be signed in to access"
  end

  test "update" do
    user = insert(:user)
    old_pass = user.password_hash

    conn = put login(user), "/rider", user: %{
      name:   "Updated user",
      password: "newpassword",
      avatar: build_upload()
    }
    assert redirected_to(conn) == "/rider/tours"
    assert get_flash(conn, :info) == "Account updated"
    user = Repo.get_by(User, id: user.id, name: "Updated user")

    assert user
    refute old_pass == user.password_hash
  end

  test "update failure" do
    user = insert(:user)
    conn = put login(user), "/rider", user: %{
      name: ""
    }
    assert response(conn, 200)
    assert template(conn) == "edit.html"
    assert get_flash(conn, :error) == "Failed to update Account"
    refute Repo.get_by(User, id: user.id, name: "")
  end
end
