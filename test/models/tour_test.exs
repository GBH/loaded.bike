defmodule LoadedBike.TourTest do
  use LoadedBike.ModelCase

  import LoadedBike.TestFactory

  alias LoadedBike.Tour

  describe "changeset" do
    test "with valid attributes" do
      user = insert(:user)
      changeset = Tour.changeset(%Tour{}, %{params_for(:tour) | user_id: user.id})
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Tour.changeset(%Tour{}, %{})
      refute changeset.valid?
    end
  end

  test "insert" do
    user = insert(:user)
    {status, _} = Repo.insert(Tour.changeset(%Tour{}, %{params_for(:tour) | user_id: user.id}))
    assert status == :ok
  end
end
