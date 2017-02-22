defmodule PedalApp.TourTest do
  use PedalApp.ModelCase

  import PedalApp.TestFactory

  alias PedalApp.Tour

  describe "changeset" do
    test "with valid attributes" do
      changeset = Tour.changeset(%Tour{}, params_for(:tour))
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Tour.changeset(%Tour{}, %{})
      refute changeset.valid?
    end
  end

  test "insert" do
    {status, huh} = Repo.insert(Tour.changeset(%Tour{}, params_for(:tour)))
    IO.inspect huh
    assert status == :ok
  end
end
