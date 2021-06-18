defmodule FrontendWeb.SessionController do
  use FrontendWeb, :controller

  alias Phoenix.LiveView
  alias Frontend.API.Users
  alias Frontend.Schemas.User

  def new(conn, _params) do
    changeset = Users.change_user_signin(%User{})

    conn
    |> put_layout(false) # disable app.html.eex layout
    |> put_root_layout(false) # disable root.html.eex layout
    |> render("signin.html", changeset: changeset)
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
