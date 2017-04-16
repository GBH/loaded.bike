defmodule LoadedBike.Web.TourViewTest do
  use LoadedBike.Web.ConnCase, async: true

  alias LoadedBike.Web.TourView

  test "waypoint_css_class" do
    assert TourView.waypoint_css_class(10, 0) == "start"
    assert TourView.waypoint_css_class(10, 9) == "finish"
    assert TourView.waypoint_css_class(10, 6) == "week"
    assert TourView.waypoint_css_class(10, 2) == ""
  end
end
