defmodule PedalApp.WaypointTest do
  use PedalApp.ModelCase

  import PedalApp.TestFactory

  alias PedalApp.Waypoint

  describe "changeset" do
    test "with valid attributes" do
      tour = insert(:tour)
      changeset = Waypoint.changeset(%Waypoint{}, %{params_for(:waypoint) | tour_id: tour.id})
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Waypoint.changeset(%Waypoint{}, %{})
      refute changeset.valid?
    end
  end

  test "insert" do
    tour = insert(:tour)
    {status, _} = Repo.insert(Waypoint.changeset(%Waypoint{}, %{params_for(:waypoint) | tour_id: tour.id}))
    assert status == :ok
  end
end