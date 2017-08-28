defmodule LoadedBike.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use LoadedBike.Web, :controller
      use LoadedBike.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      alias LoadedBike.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      use LoadedBike.Model.Helpers
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: LoadedBike.Web

      alias LoadedBike.Repo
      import Ecto
      import Ecto.Query

      import LoadedBike.Web.Router.Helpers
      import LoadedBike.Web.Gettext

      use Breadcrumble
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/loaded_bike/web/templates", namespace: LoadedBike.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import LoadedBike.Web.Router.Helpers
      import LoadedBike.Web.TranslationHelpers
      import LoadedBike.Web.Gettext

      import LoadedBike.Web.HtmlHelpers
      alias LoadedBike.Web.FormHelpers, as: F
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias LoadedBike.Repo
      import Ecto
      import Ecto.Query
      import LoadedBike.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
