defmodule PedalApp.Router do
  use PedalApp.Web, :router

  pipeline :login_required do

  end

  pipeline :admin_required do

  end

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
    plug PedalApp.CurrentUser
  end

  scope "/", PedalApp do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/tours", TourController, only: [:index, :show]

    resources "/riders", UserController, only: [:show] do
      resources "/tours", TourController, only: [:index, :show]
    end

    resources "/rider", UserController, only: [:new, :create, :edit, :update], singleton: true do
      resources "/tours", TourController
    end
  end

end
