defmodule FrontendWeb.ErrorHandler do
  import Plug.Conn
  use Phoenix.Controller

  def policy_error(conn, :forbidden) do
    conn
    |> put_flash(:error, "You do not have sufficient permissions to view this page.")
    |> redirect(to: "/boards")
  end

  def policy_error(conn, _error) do
    conn
    |> put_view(FrontendWeb.ErrorView)
    |> render("error_page.html")
    |> halt()
  end

  def unauthenticated(conn, message) do
    conn
    |> put_view(FrontendWeb.ErrorView)
    |> render("error_page.html", :message, message)
    |> halt()
  end
end
