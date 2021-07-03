defmodule FrontendWeb.SessionController do
  use FrontendWeb, :controller

  alias Phoenix.LiveView
  alias Frontend.API.Session
  alias Frontend.Schemas.User

  # plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _params) do
    changeset = Session.change_user_signin(%User{})

    conn
    |> put_layout(false) # disable app.html.eex layout
    |> put_root_layout(false) # disable root.html.eex layout
    |> render("signin.html", changeset: changeset)
  end

  def create(conn, %{"user" => user}) do
    case Session.create_session(user) do
      {:ok, %{user: user, token: token}} ->
        conn
        |> put_session(:user, user)
        |> put_session(:token, token)
        |> put_flash(:info, "Successfully logged in.")
        |> redirect(to: Routes.board_path(conn, :index))
      {:error, _params} ->
        changeset = Session.change_user_signin(%User{})
        conn
        |> put_flash(:error, "Failed to log in.")
        |> render("signin.html", changeset: changeset)
    end
  end

  def test(conn, _params) do
    conn
    |> put_layout(false) # disable app.html.eex layout
    |> put_root_layout(false) # disable root.html.eex layout
    |> render("test.html")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user)
    |> delete_session(:token)
    |> put_flash(:info, "See you again soon!")
    |> redirect(to: Routes.session_path(conn, :new))
  end

  # def signup(conn, test) do
  #   changeset = Users.change_user(%User{})

  #   conn
  #   |> put_layout(false) # disable app.html.eex layout
  #   |> put_root_layout(false) # disable root.html.eex layout
  #   |> render("signup.html", changeset: changeset)
  # end

  # def signin(conn, test) do
  #   conn
  #   |> put_layout(false) # disable app.html.eex layout
  #   |> put_root_layout(false) # disable root.html.eex layout
  #   |> render("signin.html")
  # end

  # use BackendWeb, :controller

  # plug :scrub_params, "session" when action in ~w(create)a

  # def new(conn, _) do
  #   render conn, "new.html"
  # end

  # def create(conn, %{"session" => %{"email" => email, "password" => password}}) do

  #   # here will be an implementation
  # end

  # def delete(conn, _) do
  #   # here will be an implementation
  # end
end
