defmodule PedalApp.UserTest do
  use PedalApp.ModelCase

  alias PedalApp.User

  describe "changeset" do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, params_for(:user))
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = User.changeset(%User{}, %{})
      refute changeset.valid?
      assert errors_on(changeset) == [:email, :name]
    end
  end

  describe "registration changeset" do
    test "with valid attributes" do
      changeset = User.registration_changeset(%User{}, %{params_for(:user) | password: "passpass"})
      assert changeset.valid?
      refute changeset.changes.password_hash == ""
    end

    test "with invalid attributes" do
      changeset = User.registration_changeset(%User{}, %{})
      refute changeset.valid?
      assert errors_on(changeset) == [:password, :email, :name]
    end
  end

  test "insert" do
    {status, _} = Repo.insert(User.registration_changeset(%User{}, %{params_for(:user) | password: "passpass"}))
    assert status == :ok
  end
end
