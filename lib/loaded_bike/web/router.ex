defmodule LoadedBike.Web.Router do
  use LoadedBike.Web, :router

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
    plug LoadedBike.CurrentUser
  end

  scope "/", LoadedBike.Web do
    pipe_through [:browser, :with_session]

    get "/", LandingController, :show

    # session management
    get     "/login",   SessionController, :new
    post    "/login",   SessionController, :create
    delete  "/logout",  SessionController, :delete

    resources "/tours", TourController, only: [:index, :show]

    resources "/riders", UserController, only: [:show] do
      resources "/tours", TourController, only: [:index, :show] do
        resources "/waypoints", WaypointController, only: [:index, :show]
      end
    end

    # -- logged-in user routes -------------------------------------------------
    resources "/rider", UserController,
      only:       [:new, :create, :edit, :update],
      name:       "current_user",
      singleton:  true
    do
      resources "/tours", User.TourController do
        resources "/waypoints", User.WaypointController, except: [:index] do
          resources "/photos", User.PhotoController
        end
      end
    end
  end
end
