defmodule Pedal.RiderTest do
  use Pedal.ModelCase

  alias Pedal.Rider

  @valid_attrs %{email: "some content", name: "some content", password_hash: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Rider.changeset(%Rider{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Rider.changeset(%Rider{}, @invalid_attrs)
    refute changeset.valid?
  end
end
