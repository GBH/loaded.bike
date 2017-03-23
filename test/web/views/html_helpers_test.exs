defmodule PedalApp.Web.MarkdownHelperTest do
  use PedalApp.Web.ConnCase, async: true

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

  test "waypoints_to_json" do
    flunk "todo"
  end

  test "published_badge" do
    flunk "todo"
  end
end