defmodule LoadedBike.TestFactory do

  use ExMachina.Ecto, repo: LoadedBike.Repo

  alias LoadedBike.{User, Tour, Waypoint, Photo}

  def user_factory do
    %User{
      email:          "test@example.org",
      name:           "Test User",
      password_hash:  Comeonin.Bcrypt.hashpwsalt("password")
    }
  end

  def tour_factory do
    %Tour{
      user:               build(:user),
      title:              "Test Tour",
      description:        "Test Tour Description",
      short_description:  "Test Tour Short Description",
      is_published:       true
    }
  end

  def waypoint_factory do
    %Waypoint{
      tour:         build(:tour),
      title:        "Test Waypoint",
      description:  "Test Waypoint Description",
      lat:          49.262206,
      lng:          -123.2616348,
      is_published: true
    }
  end

  def photo_factory do
    %Photo{
      waypoint:     build(:waypoint),
      uuid:         "fa196fb0-9445-4da1-923e-d71f43ee170e",
      description:  "Test Photo Description",
      file:         %{file_name: "test/files/test.jpg", updated_at: Ecto.DateTime.utc}
    }
  end
end