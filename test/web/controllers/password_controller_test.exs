defmodule LoadedBike.Web.PasswordControllerTest do
  use LoadedBike.Web.ConnCase
  use Bamboo.Test

  test "new" do
    conn = get build_conn(), "/password/new"
    assert response(conn, 200)
    assert template(conn) == "new.html"
  end

  test "create" do
    user = insert(:user)
    conn = post build_conn(), "/password", password: %{
      email: user.email
    }
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Password reset email is sent"

    user = Repo.get_by(User, email: user.email)
    assert String.match?(user.password_reset_token, ~r/\w{32}/)

    email = LoadedBike.Email.password_reset(user)
    assert_delivered_email email
    assert email.html_body =~ user.password_reset_token
  end

  test "create invalid" do
    conn = post build_conn(), "/password", password: %{
      email: "invalid"
    }
    assert response(conn, 200)
    assert template(conn) == "new.html"
    assert get_flash(conn, :error) == "No account found with this email"
  end

  test "edit" do
    user = insert(:user, %{password_reset_token: "123abc"})
    conn = get build_conn(), "/password/edit", token: user.password_reset_token
    assert response(conn, 200)
    assert template(conn) == "edit.html"
  end

  test "edit with invalid token" do
    conn = get build_conn(), "/password/edit", token: "invalid"
    assert redirected_to(conn) == "/password/new"
    assert get_flash(conn, :error) == "Invalid password reset token"
  end

  test "update" do
    user = insert(:user, %{password_reset_token: "123abc"})
    conn = put build_conn(), "/password", token: user.password_reset_token, password: %{
      password: "newpassword"
    }
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Password successfully changed"

    user = Repo.get_by(User, email: user.email)
    refute user.password_reset_token
    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "update with invalid password" do
    user = insert(:user, %{password_reset_token: "123abc"})
    conn = put build_conn(), "/password", token: user.password_reset_token, password: %{
      password: "short"
    }
    assert response(conn, 200)
    assert template(conn) == "edit.html"
    assert get_flash(conn, :error) == "Invalid password"
  end
end
