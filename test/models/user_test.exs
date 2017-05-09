defmodule LoadedBike.UserTest do
  use LoadedBike.ModelCase

  alias LoadedBike.User

  describe "changeset" do
    test "with valid attributes" do
      user = insert(:user)
      changeset = User.changeset(user, params_for(:user))
      assert changeset.valid?
    end

    test "with invalid attributes" do
      user = insert(:user)
      changeset = User.changeset(user, %{email: "", name: "", password: ""})
      refute changeset.valid?
      assert errors_on(changeset) == [:email, :name]
    end
  end

  describe "registration changeset" do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, %{params_for(:user) | password: "passpass"})
      assert changeset.valid?
      refute changeset.changes.password_hash == ""
    end

    test "with invalid attributes" do
      changeset = User.changeset(%User{}, %{})
      refute changeset.valid?
      assert errors_on(changeset) == [:password, :email, :name]
    end
  end

  test "insert" do
    {status, _} = Repo.insert(User.changeset(%User{}, %{params_for(:user) | password: "passpass"}))
    assert status == :ok
  end

  test "generate_password_reset_token!" do
    user = insert(:user)
    user = User.generate_password_reset_token!(user)
    assert String.match?(user.password_reset_token, ~r/\w{32}/)
  end

  test "change_password!" do
    user = insert(:user, %{password_reset_token: "abc123"})
    old_password = user.password_hash
    {:ok, user} = User.change_password!(user, "newpassword")
    refute old_password == user.password
    refute user.password_reset_token
  end

  test "change_password! invalid password" do
    user = insert(:user)
    {:error, changeset} = User.change_password!(user, "short")
    assert errors_on(changeset) == [:password]
  end
end
