defmodule LoadedBike.Web.WaypointViewTest do
  use LoadedBike.Web.ConnCase, async: true
  import Poison.Parser, only: [parse: 1]

  alias LoadedBike.Web.WaypointView

  test "waypoints_to_json urls", %{conn: conn} do
    waypoint = insert(:waypoint)
    tour = %{waypoint.tour | waypoints: [waypoint]}

    json = [%{
      "url"         => "/rider/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}",
      "title"       => "Test Waypoint",
      "lng"         => -123.2616348,
      "lat"         => 49.262206,
      "is_finish"   => true,
      "is_planned"  => false
    }]
    assert parse(WaypointView.waypoints_to_json(conn, tour, :private)) == {:ok, json}

    json = [%{
      "url"         => "/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}",
      "title"       => "Test Waypoint",
      "lng"         => -123.2616348,
      "lat"         => 49.262206,
      "is_finish"   => true,
      "is_planned"  => false
    }]
    assert parse(WaypointView.waypoints_to_json(conn, tour, :public)) == {:ok, json}
  end

  test "waypoints_to_json is_finish", %{conn: conn} do
    tour = insert(:tour, %{status: :active})
    waypoint = insert(:waypoint, %{tour: tour})
    tour = %{tour | waypoints: [waypoint]}

    json = [%{
      "url"         => "/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}",
      "title"       => "Test Waypoint",
      "lng"         => -123.2616348,
      "lat"         => 49.262206,
      "is_planned"  => false
    }]
    assert parse(WaypointView.waypoints_to_json(conn, tour, :public)) == {:ok, json}
  end

  test "waypoints_to_json prev and next flags", %{conn: conn} do
    waypoint = insert(:waypoint)
    tour = %{waypoint.tour | waypoints: [waypoint]}
    json = [%{
      "url"         => "/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}",
      "title"       => "Test Waypoint",
      "lng"         => -123.2616348,
      "lat"         => 49.262206,
      "is_current"  => true,
      "is_previous" => true,
      "is_finish"   => true,
      "is_planned"  => false
    }]
    assert parse(WaypointView.waypoints_to_json(conn, tour, :public, waypoint, waypoint)) == {:ok, json}
  end
end
