defmodule LoadedBike.Repo do
  use Ecto.Repo, otp_app: :loaded_bike
  use Kerosene, per_page: 10
end
