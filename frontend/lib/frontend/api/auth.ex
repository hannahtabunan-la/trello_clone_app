defmodule Frontend.API.Auth do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.User
  alias Frontend.API.Session

  @success_codes 200..399

  # def auth(params) do

  # end

  # defp from_response(%{"user"=>user, "token"=>token}) do
  #   changeset = %User{}
  #   |> User.changeset(user)
  #   |> Changeset.apply_changes()

  #   %{"user": changeset, "token": token }
  # end

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://localhost:7000/api"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
