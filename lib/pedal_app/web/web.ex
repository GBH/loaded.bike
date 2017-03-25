defmodule PedalApp.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use PedalApp.Web, :controller
      use PedalApp.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      use PedalApp.Model.Helpers
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: PedalApp.Web

      alias PedalApp.Repo
      import Ecto
      import Ecto.Query

      import PedalApp.Web.Router.Helpers
      import PedalApp.Web.Gettext

      use Breadcrumble
      use PedalApp.Web.Controller.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/pedal_app/web/templates", namespace: PedalApp.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PedalApp.Web.Router.Helpers
      import PedalApp.Web.ErrorHelpers
      import PedalApp.Web.Gettext

      import PedalApp.Web.HtmlHelpers
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

      alias PedalApp.Repo
      import Ecto
      import Ecto.Query
      import PedalApp.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
