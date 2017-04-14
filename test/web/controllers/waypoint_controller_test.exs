defmodule LoadedBike.Web.WaypointControllerTest do
  use LoadedBike.Web.ConnCase

  test "show" do
    waypoint = insert(:waypoint)
    tour = waypoint.tour
    conn = get build_conn(), "/tours/#{tour.id}/waypoints/#{waypoint.id}"
    assert response(conn, 200)
    assert template(conn) == "show.html"
    assert assigns(conn, :waypoint)
  end

  test "show not found" do
    tour = insert(:tour)
    assert_error_sent 404, fn ->
      get build_conn(), "/tours/#{tour.id}/waypoints/0"
    end
  end

  test "show unpublished" do
    waypoint = insert(:waypoint, %{is_published: false})
    assert_error_sent 404, fn ->
      get build_conn(), "/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}"
    end
  end
end
