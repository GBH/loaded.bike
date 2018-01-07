defmodule LoadedBike.Web.SharedViewTest do
  use LoadedBike.Web.ConnCase, async: true
  import Phoenix.HTML, only: [safe_to_string: 1]

  alias LoadedBike.Web.SharedView

  test "disqus for tour" do
    conn = get build_conn(), "/"
    tour = insert(:tour)
    html = SharedView.disqus(conn, tour)
    |> safe_to_string

    assert html =~ ~r/this\.page\.url\s+=\s+"#{tour_url(conn, :show, tour.id)}"/
    assert html =~ ~r/this\.page\.identifier\s+=\s+"#{tour.id}"/
  end

  test "disqus for waypoint" do
    conn = get build_conn(), "/"
    waypoint = insert(:waypoint)
    tour = waypoint.tour
    html = SharedView.disqus(conn, waypoint)
    |> safe_to_string

    assert html =~ ~r/this\.page\.url\s+=\s+"#{tour_waypoint_url(conn, :show, tour.id, waypoint.id)}"/
    assert html =~ ~r/this\.page\.identifier\s+=\s+"#{tour.id}.#{waypoint.id}"/
  end
end
