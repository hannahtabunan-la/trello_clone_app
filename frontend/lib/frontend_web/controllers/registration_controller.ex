defmodule FrontendWeb.RegistrationController do
  use FrontendWeb, :controller

  alias Phoenix.LiveView
  alias Frontend.API.Users
  alias Frontend.Schemas.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, test) do
    changeset = Users.change_user(%User{})

    conn
    |> put_layout(false) # disable app.html.eex layout
    |> put_root_layout(false) # disable root.html.eex layout
    |> render("signup.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    case Users.create_user(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account is successfully created! You can now sign in.")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "signup.html", changeset: changeset)

      error ->
        render(conn, "signup.html")
    end
  end
end
