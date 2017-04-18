defmodule LoadedBike.Web.TourViewTest do
  use LoadedBike.Web.ConnCase, async: true
  import Phoenix.HTML, only: [safe_to_string: 1]

  alias LoadedBike.Web.TourView

  test "waypoint_css_class" do
    tour = insert(:tour)
    for _ <- 1..10, do: insert(:waypoint, %{tour: tour})
    tour = Repo.preload(tour, :waypoints)

    assert TourView.waypoint_css_class(tour, 0) == "start"
    assert TourView.waypoint_css_class(tour, 2) == ""
    assert TourView.waypoint_css_class(tour, 6) == "week"
    assert TourView.waypoint_css_class(tour, 9) == "finish"

    tour = %{tour | is_completed: false}
    assert TourView.waypoint_css_class(tour, 9) == ""
  end

  test "completed_badge" do
    assert TourView.completed_badge(true)
    |> safe_to_string
    |> Floki.find("span")
    |> Floki.text == "Completed"

    assert TourView.completed_badge(false)
    |> safe_to_string
    |> Floki.find("span")
    |> Floki.text == "On the road"
  end
end
