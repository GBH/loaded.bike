defmodule PedalApp.Web.WaypointViewTest do
  use PedalApp.Web.ConnCase, async: true

  alias PedalApp.Web.WaypointView

  test "markdown" do
    {:safe, html} = WaypointView.markdown("**bold**")
    assert html == "<p><strong>bold</strong></p>"
  end

  test "markdown with nil" do
    assert WaypointView.markdown(nil) == ""
  end

  test "markdown sanitized" do
    {:safe, html} = WaypointView.markdown("<script>alert('test')</script>")
    assert html == "<p>alert(‘test’)</p>"
  end
end
