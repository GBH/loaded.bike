defmodule Pedal.Router do
  use Pedal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Pedal.CurrentUser
  end

  scope "/", Pedal do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/users", UserController, only: [:show, :new, :create]
  end

end
