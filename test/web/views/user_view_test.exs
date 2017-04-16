defmodule LoadedBike.Web.UserViewTest do
  use LoadedBike.Web.ConnCase, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]

  alias LoadedBike.Web.UserView

  test "avatar_img" do
    user = insert(:user, %{avatar: %{file_name: "test/files/test.jpg", updated_at: Ecto.DateTime.utc}})

    assert UserView.avatar_img(user, :tiny)
      |> safe_to_string
      |> Floki.find("img")
      |> Floki.attribute("src")
      |> List.first
      |> String.replace(~r/\?v=.*/, "") == "/uploads/users/#{user.id}/tiny.jpg"
  end

  test "avatar_img with gravatar fallback" do
    user = insert(:user)
    assert UserView.avatar_img(user, :tiny)
      |> safe_to_string
      |> Floki.find("img")
      |> Floki.attribute("src")
      |> List.first == "https://www.gravatar.com/avatar/0c17bf66e649070167701d2d3cd71711?s=20"
  end
end
