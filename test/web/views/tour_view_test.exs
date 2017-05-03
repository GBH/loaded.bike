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

    tour = %{tour | status: :active}
    assert TourView.waypoint_css_class(tour, 9) == ""
  end

  test "status_badge" do
    assert TourView.status_badge(:completed)
    |> safe_to_string
    |> Floki.find("span")
    |> Floki.text == "Completed"

    assert TourView.status_badge(:active)
    |> safe_to_string
    |> Floki.find("span")
    |> Floki.text == "On the road"

    assert TourView.status_badge(:planned)
    |> safe_to_string
    |> Floki.find("span")
    |> Floki.text == "Planned"
  end
end
