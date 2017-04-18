defmodule LoadedBike.Web.WaypointViewTest do
  use LoadedBike.Web.ConnCase, async: true
  import Poison.Parser, only: [parse: 1]

  alias LoadedBike.Web.WaypointView

  test "waypoints_to_json" do
    waypoint = insert(:waypoint)
    conn = get build_conn(), "/"

    json = [%{
      "url"         => "/rider/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}",
      "title"       => "Test Waypoint",
      "lng"         => -123.2616348,
      "lat"         => 49.262206,
      "is_previous" => false,
      "is_current"  => false
    }]
    assert parse(WaypointView.waypoints_to_json(conn, :private, [waypoint])) == {:ok, json}

    json = [%{
      "url"         => "/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}",
      "title"       => "Test Waypoint",
      "lng"         => -123.2616348,
      "lat"         => 49.262206,
      "is_previous" => false,
      "is_current"  => false
    }]
    assert parse(WaypointView.waypoints_to_json(conn, :public, [waypoint])) == {:ok, json}
  end
end
