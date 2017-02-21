defmodule PedalApp.TourTest do
  use PedalApp.ModelCase

  alias PedalApp.Tour

  @valid_attrs %{description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tour.changeset(%Tour{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tour.changeset(%Tour{}, @invalid_attrs)
    refute changeset.valid?
  end
end
