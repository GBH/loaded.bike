defmodule LoadedBike.Web.Router do
  use LoadedBike.Web, :router
  use Plug.ErrorHandler

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    Rollbax.report(kind, reason, stacktrace, %{params: conn.params})
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated, handler: LoadedBike.Web.Auth.GuardianErrorHandler
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
    plug LoadedBike.Web.Auth.CurrentUser
  end

  scope "/", LoadedBike.Web do
    pipe_through [:browser, :with_session]

    # -- public resources ------------------------------------------------------
    get "/", LandingController, :show

    resources "/rider", UserController,
      only:       [:new, :create],
      name:       "current_user",
      singleton:  true

    resources "/riders", UserController, only: [:show]
    resources "/tours", TourController, only: [:index, :show] do
      resources "/waypoints", WaypointController, only: [:show]
    end

    # -- session management ----------------------------------------------------
    get     "/signin",  SessionController, :new
    post    "/signin",  SessionController, :create
    delete  "/signout", SessionController, :delete

    # -- logged-in user routes -------------------------------------------------
    scope "/" do
      pipe_through [:login_required]

      resources "/rider", UserController,
        only:       [:edit, :update],
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
end
