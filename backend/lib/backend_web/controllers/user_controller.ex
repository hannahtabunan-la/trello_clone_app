defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Models.Users
  alias Backend.Schemas.User
  alias BackendWeb.Auth.Guardian

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
    {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def signin(conn, %{"username" => username, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(username, password) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end
end
