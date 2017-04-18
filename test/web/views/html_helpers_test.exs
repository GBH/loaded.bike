defmodule LoadedBike.Web.MarkdownHelperTest do
  use LoadedBike.Web.ConnCase, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]

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