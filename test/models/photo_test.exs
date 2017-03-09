defmodule PedalApp.PhotoTest do
  use PedalApp.ModelCase

  alias PedalApp.Photo

  defp build_upload(path \\ "test/files/test.jpg") do
    %{__struct__: Plug.Upload, content_type: "image/jpg", path: path, filename: Path.basename(path)}
  end

  describe "changeset" do
    test "with valid attributes" do
      waypoint = insert(:waypoint)
      changeset = Photo.changeset(%Photo{}, %{params_for(:photo) | waypoint_id: waypoint.id, file: build_upload()})
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Photo.changeset(%Photo{}, %{})
      refute changeset.valid?
    end
  end

end
