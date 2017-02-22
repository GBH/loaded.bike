defmodule PedalApp.UserTest do
  use PedalApp.ModelCase

  import PedalApp.TestFactory

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

    test "for registration" do
      changeset = User.registration_changeset(%User{}, %{
        email: "test@example.com", name: "Test User", password: "passpass"
      })
      assert changeset.valid?
      refute changeset.changes.password_hash == ""
    end
  end
end
