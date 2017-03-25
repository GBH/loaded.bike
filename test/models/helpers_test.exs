defmodule PedalApp.Model.HelpersTest do
  use PedalApp.ModelCase

  test "dom_id" do
    photo = insert(:photo)
    assert PedalApp.Photo.dom_id(photo) == "photo-#{photo.id}"
  end
end