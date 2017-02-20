defmodule Pedal.Router do
  use Pedal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Pedal do
    pipe_through :browser

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/riders", RiderController, only: [:show, :new, :create]
  end

end
