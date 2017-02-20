defmodule Pedal.RiderController do
  use Pedal.Web, :controller

  alias Pedal.Rider

  def new(conn, _params) do
    changeset = Rider.changeset(%Rider{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"rider" => params}) do
    changeset = %Rider{} |> Rider.registration_changeset(params)

    case Repo.insert(changeset) do
      {:ok, rider} ->
        conn
        |> put_flash(:info, "#{rider.name} created")
        |> redirect(to: rider_path(conn, :show, rider))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rider = Repo.get!(Rider, id)
    render(conn, "show.html", rider: rider)
  end
end