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

  def create(conn, %{"email" => email, "password" => password}) do
    # case Session.create_session(params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "Successfully logged in!")
    #     |> redirect(to: Routes.ping_path(conn, :show))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "signin.html", changeset: changeset)

    #   error ->
    #     render(conn, "signin.html")
    # end
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
