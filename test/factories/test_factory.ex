defmodule PedalApp.TestFactory do

  use ExMachina.Ecto, repo: PedalApp.Repo

  alias PedalApp.{User, Tour}

  def user_factory do
    %User{
      email:          "test@example.org",
      name:           "Test User",
      password_hash:  Comeonin.Bcrypt.hashpwsalt("password")
    }
  end

  def tour_factory do
    %Tour{
      title:        "Test Tour",
      description:  "Test Description",
      user:         build(:user)
    }
  end
end