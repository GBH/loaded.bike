defmodule LoadedBike.Email do
  import Bamboo.Email

  def password_reset(user) do
    new_email()
    |> to(user.email)
    |> from("oleg@loaded.bike")
    |> subject("Loaded.bike Password Reset")
    |> html_body(user.password_reset_token)
  end
end
