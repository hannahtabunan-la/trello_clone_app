defmodule Frontend.API.Session do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.User
  alias Frontend.API.Session

  @success_codes 200..399

  def change_user_signin(%User{} = user, attrs \\ %{}) do
    User.signin_changeset(user, attrs)
  end

  def create_session(params) do
    url = "/signin"

    with %{valid?: true} = changeset <- User.signin_changeset(%User{}, params),
         user <- Changeset.apply_changes(changeset),
         client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, user) do
          # %{"user"=>user, "token"=>token} = body
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def delete_session(params) do
    url = "/signout"
    {access_token, _params} = Map.pop(params, "access_token")

    with client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url) do
          # %{"user"=>user, "token"=>token} = body
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
    url = Application.get_env(:frontend, :api_url)

    middleware = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams
    ]

    Tesla.client(middleware)
  end

  def client(access_token) do
    url = Application.get_env(:frontend, :api_url)

    middleware = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{access_token}"}]},
    ]

    Tesla.client(middleware)
  end
end
