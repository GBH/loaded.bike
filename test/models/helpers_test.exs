defmodule LoadedBike.Model.HelpersTest do
  use LoadedBike.ModelCase

  test "dom_id" do
    photo = insert(:photo)
    assert LoadedBike.Photo.dom_id(photo) == "photo-#{photo.id}"
  end
end