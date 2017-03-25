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

    test "position setting" do
      waypoint = insert(:waypoint)
      changeset = Waypoint.changeset(%Waypoint{}, %{params_for(:waypoint) | tour_id: waypoint.tour_id})
      assert changeset.changes.position == 1
    end

    test "position setting for existing record" do
      waypoint = insert(:waypoint, position: 99)
      changeset = Waypoint.changeset(waypoint, %{title: "Updated"})
      refute changeset.changes[:position]
    end
  end

  test "insert" do
    tour = insert(:tour)
    {status, _} = Repo.insert(Waypoint.changeset(%Waypoint{}, %{params_for(:waypoint) | tour_id: tour.id}))
    assert status == :ok
  end

  test "to_json" do
    waypoint = insert(:waypoint)
    assert Poison.encode!(waypoint) == "{\"title\":\"Test Waypoint\",\"lng\":-123.2616348,\"lat\":49.262206}"
  end
end