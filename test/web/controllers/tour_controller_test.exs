defmodule LoadedBike.Web.TourControllerTest do
  use LoadedBike.Web.ConnCase

  test "index" do
    insert(:tour)
    conn = get build_conn(), "/tours"
    assert response(conn, 200)
    assert template(conn) == "index.html"
    assert length(assigns(conn, :tours)) == 1
  end

  test "index with unpublished" do
    insert(:tour, %{is_published: false})
    conn = get build_conn(), "/tours"
    assert response(conn, 200)
    assert length(assigns(conn, :tours)) == 0
  end

  test "show" do
    waypoint = insert(:waypoint)
    tour = waypoint.tour
    conn = get build_conn(), "/tours/#{tour.id}-test-tour"
    assert response(conn, 200)
    assert template(conn) == "show.html"
    assert length(assigns(conn, :tour).waypoints) == 1
  end

  test "show not found" do
    assert_error_sent 404, fn ->
      get build_conn(), "/tours/0"
    end
  end

  test "show unpublished" do
    tour = insert(:tour, %{is_published: false})
    assert_error_sent 404, fn ->
      get build_conn(), "/tours/#{tour.id}"
    end
  end

  test "show with unpublished waypoints" do
    waypoint = insert(:waypoint, %{is_published: false})
    tour = waypoint.tour
    conn = get build_conn(), "/tours/#{tour.id}"
    assert response(conn, 200)
    assert length(assigns(conn, :tour).waypoints) == 0
  end
end
