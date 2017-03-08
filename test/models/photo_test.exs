defmodule PedalApp.PhotoTest do
  use PedalApp.ModelCase

  alias PedalApp.Photo

  @valid_attrs %{description: "some description", file: "some file", position: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Photo.changeset(%Photo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Photo.changeset(%Photo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
