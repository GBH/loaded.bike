defmodule PedalApp.Web.MarkdownHelperTest do
  use PedalApp.Web.ConnCase, async: true

  alias PedalApp.Web.MarkdownHelper

  test "markdown" do
    {:safe, html} = MarkdownHelper.markdown("**bold**")
    assert html == "<p><strong>bold</strong></p>"
  end

  test "markdown with nil" do
    assert MarkdownHelper.markdown(nil) == ""
  end

  test "markdown sanitized" do
    {:safe, html} = MarkdownHelper.markdown("<script>alert('test')</script>")
    assert html == "<p>alert(‘test’)</p>"
  end
end