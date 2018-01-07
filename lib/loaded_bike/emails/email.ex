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

  def verify_account(conn, user) do
    url = current_user_user_url(conn, :verify, token: user.verification_token)

    new_email()
    |> from("oleg@loaded.bike")
    |> to({user.name, user.email})
    |> postageapp_template("verify-account")
    |> postageapp_variables(%{verify_url: url})
  end

  def comment_callback(user, url, comment) do
    new_email()
    |> from("oleg@loaded.bike")
    |> to({user.name, user.email})
    |> postageapp_template("comment-callback")
    |> postageapp_variables(%{
      url:      url,
      comment:  comment
    })
  end
end
