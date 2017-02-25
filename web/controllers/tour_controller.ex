defmodule PedalApp.TourController do
  use PedalApp.Web, :controller

  alias PedalApp.{User, Tour}

  plug :scrub_params, "tour" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _, _current_user) do

  end

  def new(conn, _, current_user) do
    changeset = current_user
    |> build_assoc(:tours)
    |> Tour.changeset

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tour" => tour_params}, current_user) do

  end

  def edit(conn, %{"id" => id}, current_user) do

  end

  def update(conn, %{"id" => id, "tour" => tour_params}, current_user) do

  end

  def delete(conn, %{"id" => id}, current_user) do

  end
end