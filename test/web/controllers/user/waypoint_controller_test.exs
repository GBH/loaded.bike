defmodule LoadedBike.Web.User.WaypointControllerTest do
  use LoadedBike.Web.ConnCase

  alias LoadedBike.Waypoint

  setup do
    user = insert(:user)
    tour = insert(:tour, user: user)
    conn = login(user)
    {:ok, conn: conn, tour: tour}
  end

  test "show", %{conn: conn, tour: tour} do
    waypoint = insert(:waypoint, %{tour: tour})
    conn = get conn, "rider/tours/#{tour.id}/waypoints/#{waypoint.id}"
    assert response(conn, 200)
    assert template(conn) == "show.html"
    assert assigns(conn, :tour)
    assert assigns(conn, :waypoint)
  end

  test "show not found", %{conn: conn, tour: tour} do
    assert_error_sent 404, fn ->
      get conn, "/rider/tours/#{tour.id}/waypoints/0"
    end
  end

  test "new", %{conn: conn, tour: tour} do
    conn = get conn, "/rider/tours/#{tour.id}/waypoints/new"
    assert response(conn, 200)
    assert template(conn) == "new.html"
    changeset = assigns(conn, :changeset)
    assert Ecto.Changeset.get_change(changeset, :is_published)
  end

  test "create", %{conn: conn, tour: tour} do
    conn = post conn, "/rider/tours/#{tour.id}/waypoints", waypoint: %{
      title:        "Test Waypoint",
      description:  "Test Description",
      lat:          "12.34",
      lng:          "56.78"
    }
    waypoint = Repo.one(Waypoint)
    assert redirected_to(conn) == "/rider/tours/#{tour.id}/waypoints/#{waypoint.id}"
    assert get_flash(conn, :info) == "Waypoint created"
  end

  test "create failure", %{conn: conn, tour: tour} do
    conn = post conn, "/rider/tours/#{tour.id}/waypoints", waypoint: %{}
    assert response(conn, 200)
    assert template(conn) == "new.html"
    assert get_flash(conn, :error) == "Failed to create Waypoint"
  end

  test "edit", %{conn: conn, tour: tour} do
    waypoint = insert(:waypoint, tour: tour)
    conn = get conn, "/rider/tours/#{tour.id}/waypoints/#{waypoint.id}/edit"
    assert response(conn, 200)
    assert template(conn) == "edit.html"
    assert assigns(conn, :waypoint)
    assert assigns(conn, :changeset)
  end

  test "update", %{conn: conn, tour: tour} do
    waypoint = insert(:waypoint, tour: tour)
    conn = put conn, "/rider/tours/#{tour.id}/waypoints/#{waypoint.id}", waypoint: %{
      title: "Updated waypoint"
    }
    assert redirected_to(conn) == "/rider/tours/#{tour.id}/waypoints/#{waypoint.id}"
    assert get_flash(conn, :info) == "Waypoint updated"
    assert Repo.get_by(Waypoint, id: waypoint.id, title: "Updated waypoint")
  end

  test "update failure", %{conn: conn, tour: tour} do
    waypoint = insert(:waypoint, tour: tour)
    conn = put conn, "/rider/tours/#{tour.id}/waypoints/#{waypoint.id}", waypoint: %{
      title: ""
    }
    assert response(conn, 200)
    assert template(conn) == "edit.html"
    assert get_flash(conn, :error) == "Failed to update Waypoint"
    refute Repo.get_by(Waypoint, id: waypoint.id, title: "")
  end

  test "delete", %{conn: conn, tour: tour} do
    waypoint = insert(:waypoint, tour: tour)
    conn = delete conn, "/rider/tours/#{tour.id}/waypoints/#{waypoint.id}"
    assert redirected_to(conn) == "/rider/tours/#{tour.id}"
    refute Repo.get(Waypoint, waypoint.id)
  end
end
