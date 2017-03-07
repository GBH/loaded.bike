defmodule PedalApp.TestFactory do

  use ExMachina.Ecto, repo: PedalApp.Repo

  alias PedalApp.{User, Tour, Waypoint}

  def user_factory do
    %User{
      email:          "test@example.org",
      name:           "Test User",
      password_hash:  Comeonin.Bcrypt.hashpwsalt("password")
    }
  end

  def tour_factory do
    %Tour{
      user:         build(:user),
      title:        "Test Tour",
      description:  "Test Description"
    }
  end

  def waypoint_factory do
    %Waypoint{
      tour:         build(:tour),
      title:        "Test Waypoint",
      description:  "Test Description",
      lat:          49.262206,
      long:         -123.2616348
    }
  end
end