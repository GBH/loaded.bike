defmodule LoadedBike.Email do
  import Bamboo.Email
  import Bamboo.PostageAppHelper
  import LoadedBike.Web.Router.Helpers

  def password_reset(conn, user) do

    url = password_url(conn, :edit, token: user.password_reset_token)

    new_email()
    |> from("oleg@loaded.bike")
    |> to({user.name, user.email})
    |> postageapp_template("password-reset")
    |> postageapp_variables(%{password_reset_url: url})
  end
end
