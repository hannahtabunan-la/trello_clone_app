defmodule BackendWeb.AccountController do
  use BackendWeb, :controller

  alias Backend.Users
  alias Backend.Schemas.User
  alias BackendWeb.Auth.Guardian

  action_fallback BackendWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create_user(params),
    {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("account.json", %{user: user, token: token})
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> render("account.json", %{user: user, token: token})
    end
  end

  def delete(conn, _) do
    conn
    |> logout
    |> render("account.json", %{user: nil})
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end
