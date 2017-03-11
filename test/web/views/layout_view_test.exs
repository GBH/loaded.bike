defmodule PedalApp.Web.LayoutViewTest do
  use PedalApp.Web.ConnCase, async: true

  alias PedalApp.Web.LayoutView

  test "page_identifier" do
    conn = get build_conn(), "/"
    assert LayoutView.page_identifier(conn) == "PageIndexView"
  end
end
