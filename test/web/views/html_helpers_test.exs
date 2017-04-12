defmodule LoadedBike.Web.MarkdownHelperTest do
  use LoadedBike.Web.ConnCase, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]
  import Poison.Parser, only: [parse: 1]

  alias LoadedBike.Web.HtmlHelpers

  test "markdown" do
    {:safe, html} = HtmlHelpers.markdown("**bold**")
    assert html == "<p><strong>bold</strong></p>"
  end

  test "markdown with nil" do
    assert HtmlHelpers.markdown(nil) == ""
  end

  test "markdown sanitized" do
    {:safe, html} = HtmlHelpers.markdown("<script>alert('test')</script>")
    assert html == "<p>alert(‘test’)</p>"
  end

  test "to_json" do
    waypoint = insert(:waypoint)

    json = [%{
      "lat"   => 49.262206,
      "lng"   => -123.2616348,
      "title" => "Test Waypoint"
    }]

    assert parse(HtmlHelpers.to_json([waypoint])) == {:ok, json}
  end

  test "published_badge" do
    assert HtmlHelpers.published_badge(true)
    |> safe_to_string
    |> Floki.find("span")
    |> Floki.text == "Published"

    assert HtmlHelpers.published_badge(false)
    |> safe_to_string
    |> Floki.find("span")
    |> Floki.text == "Draft"
  end

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
    assert parse(HtmlHelpers.waypoints_to_json(conn, :private, [waypoint])) == {:ok, json}

    json = [%{
      "url"         => "/tours/#{waypoint.tour_id}/waypoints/#{waypoint.id}",
      "title"       => "Test Waypoint",
      "lng"         => -123.2616348,
      "lat"         => 49.262206,
      "is_previous" => false,
      "is_current"  => false
    }]
    assert parse(HtmlHelpers.waypoints_to_json(conn, :public, [waypoint])) == {:ok, json}
  end
end