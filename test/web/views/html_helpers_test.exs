defmodule PedalApp.Web.MarkdownHelperTest do
  use PedalApp.Web.ConnCase, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]

  alias PedalApp.Web.HtmlHelpers

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
    json = "[{\"title\":\"Test Waypoint\",\"lng\":-123.2616348,\"lat\":49.262206}]"
    assert HtmlHelpers.to_json([waypoint]) == json
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
end