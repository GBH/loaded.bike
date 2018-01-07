defmodule LoadedBike.Web.UserController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{User, Tour, Waypoint, Mailer, Email}

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => params}) do
    changeset = %User{} |> User.changeset(params)

    case Repo.insert(changeset) do
      {:ok, user} ->

        Email.verify_account(conn, user) |> Mailer.deliver_later()

        conn
        |> LoadedBike.Web.Auth.login(user)
        |> put_flash(:info, "Account created")
        |> redirect(to: landing_path(conn, :show))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to create Account")
        |> render("new.html", changeset: changeset)
    end
  end

  def index(conn, params) do
    {users, paginator} = User
      |> order_by(desc: :id)
      |> preload([tours: ^Tour.published(Tour)])
      |> Repo.paginate(params)

    conn
    |> render("index.html", users: users, paginator: paginator)
  end

  def show(conn, %{"id" => id}) do
    waypoints_query = Waypoint
      |> Waypoint.published
      |> Waypoint.select_without_gps
      |> order_by(asc: :position)

    tours_query = Tour
      |> Tour.published
      |> preload(waypoints: ^waypoints_query)

    user = User
      |> preload(tours: ^tours_query)
      |> Repo.get!(id)

    conn
    |> render("show.html", user: user)
  end

  def edit(conn, _) do
    changeset = User.changeset(conn.assigns.current_user)

    conn
    |> render("edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    changeset = User.changeset(conn.assigns.current_user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Account updated")
        |> redirect(to: current_user_tour_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update Account")
        |> render("edit.html", changeset: changeset)
    end
  end

  def verify(conn, %{"token" => token}) do
    user = Repo.get_by(User, verification_token: token)
    if user do
      User.verify!(user)
      conn
      |> put_flash(:info, "Thanks for confirming your account")
      |> redirect(to: landing_path(conn, :show))
    else
      conn
      |> put_flash(:error, "Unable to find unverified user for this token")
      |> redirect(to: landing_path(conn, :show))
    end
  end

  def comment_callback(conn, %{"user_id" => id, "url" => url, "comment" => comment}) do
    user = Repo.get!(User, id)

    Email.comment_callback(user, url, comment)
    |> Mailer.deliver_later()

    send_resp(conn, :ok, "")
  end
end
