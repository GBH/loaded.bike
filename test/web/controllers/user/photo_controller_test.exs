defmodule LoadedBike.Web.User.PhotoControllerTest do
  use LoadedBike.Web.ConnCase

  import LoadedBike.Web.Test.BuildUpload

  alias LoadedBike.Photo

  setup do
    waypoint = insert(:waypoint)
    conn = login(waypoint.tour.user)
    {:ok, conn: conn, waypoint: waypoint}
  end

  test "new", %{conn: conn, waypoint: wp} do
    conn = get conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos/new"
    assert response(conn, 200)
    assert template(conn) == "new.html"
  end

  test "create", %{conn: conn, waypoint: wp} do
    conn = post conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos", photo: %{
      file:         build_upload(),
      description:  "Test Description"
    }
    photo = Repo.one(Photo)
    assert redirected_to(conn) == "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}#photo-#{photo.id}"
  end

  test "create and add more", %{conn: conn, waypoint: wp} do
    conn = post conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos", submit_more: "", photo: %{
      file:         build_upload(),
      description:  "Test Description"
    }
    assert redirected_to(conn) == "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos/new"
  end

  test "create failure", %{conn: conn, waypoint: wp} do
    conn = post conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos", photo: %{}
    assert response(conn, 200)
    assert template(conn) == "new.html"
  end

  test "edit", %{conn: conn, waypoint: wp} do
    photo = insert(:photo, waypoint: wp)
    conn = get conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos/#{photo.id}/edit"
    assert response(conn, 200)
    assert template(conn) == "edit.html"
    assert assigns(conn, :photo)
    assert assigns(conn, :changeset)
  end

  test "edit not found", %{conn: conn, waypoint: wp} do
    assert_error_sent 404, fn ->
      get conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos/0/edit"
    end
  end

  test "update", %{conn: conn, waypoint: wp} do
    photo = insert(:photo, waypoint: wp)
    conn = put conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos/#{photo.id}", photo: %{
      description: "Updated photo"
    }
    assert redirected_to(conn) == "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}#photo-#{photo.id}"
    assert Repo.get_by(Photo, id: photo.id, description: "Updated photo")
  end

  test "update failure", %{conn: conn, waypoint: wp} do
    photo = insert(:photo, waypoint: wp)
    conn = put conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos/#{photo.id}", photo: %{
      file: ""
    }
    assert response(conn, 200)
    assert template(conn) == "edit.html"
  end

  test "delete", %{conn: conn, waypoint: wp} do
    photo = insert(:photo, waypoint: wp)
    conn = delete conn, "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}/photos/#{photo.id}"
    assert redirected_to(conn) == "/rider/tours/#{wp.tour.id}/waypoints/#{wp.id}#photos"
    refute Repo.get(Photo, photo.id)
  end
end
