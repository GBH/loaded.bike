defmodule LoadedBike.PhotoTest do
  use LoadedBike.ModelCase

  alias LoadedBike.Photo

  defp build_upload(path \\ "test/files/test.jpg") do
    %{__struct__: Plug.Upload, content_type: "image/jpg", path: path, filename: Path.basename(path)}
  end

  describe "changeset" do
    test "with valid attributes" do
      waypoint = insert(:waypoint)
      params = %{params_for(:photo) | file: build_upload()}

      photo = build_assoc(waypoint, :photos)
      |> Map.put(:waypoint, waypoint)

      changeset = Photo.changeset(photo, params)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Photo.changeset(%Photo{}, %{})
      refute changeset.valid?
    end

    test "with no uuid" do
      changeset = Photo.changeset(%Photo{}, %{})
      assert String.length(changeset.changes.uuid) == 36
    end

    test "with existing uuid" do
      photo = insert(:photo)
      uuid = photo.uuid
      changeset = Photo.changeset(photo, %{uuid: "invalid"})
      assert get_field(changeset, :uuid) == uuid
    end
  end

  test "insert" do
    waypoint = insert(:waypoint)
    params = %{params_for(:photo) | file: build_upload()}

    photo = build_assoc(waypoint, :photos)
      |> Map.put(:waypoint, waypoint)

    {status, _} = Repo.insert(Photo.changeset(photo, params))
    assert status == :ok
  end

  test "delete!" do
    photo = insert(:photo)
    Photo.delete!(photo)
    refute Repo.get(Photo, photo.id)
  end
end
