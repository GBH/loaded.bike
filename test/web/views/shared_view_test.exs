defmodule LoadedBike.Web.SharedViewTest do
  use LoadedBike.Web.ConnCase, async: true

  alias LoadedBike.Web.SharedView

  import Phoenix.HTML, only: [safe_to_string: 1]

  test "disqus" do
    html = SharedView.disqus(url: "https://test.org/text", id: "test_id")
    |> safe_to_string

    assert html =~ ~r/this\.page\.url\s+=\s+"https:\/\/test\.org\/text"/
    assert html =~ ~r/this\.page\.identifier\s+=\s+"test_id"/
  end
end
