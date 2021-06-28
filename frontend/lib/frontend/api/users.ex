defmodule Frontend.API.Users do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.User
  alias Frontend.API.Users

  @success_codes 200..399

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_user_signin(%User{} = user, attrs \\ %{}) do
    User.signin_changeset(user, attrs)
  end

  def create_user(params) do
    url = "/signup"

    with %{valid?: true} = changeset <- User.changeset(%User{}, params),
         user <- Changeset.apply_changes(changeset),
         client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, user) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp from_response(%{"user"=>user, "token"=>token}) do
    changeset = %User{}
    |> User.changeset(user)
    |> Changeset.apply_changes()

    %{user: changeset, token: token }
  end

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://localhost:4000/api"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
