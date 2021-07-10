defmodule Frontend.API.Permissions do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.Permission

  @success_codes 200..399
  @types [
    :manage,
    :write,
    :read
  ]

  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end

  def create_permission(params) do
    IO.puts("+++++ BOARDS_API_CREATE +++++")
    url = "/permissions"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Permission.create_changeset(%Permission{}, params),
         permission <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, %{"permission" => permission}) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def all_permissions(params) do
    url = "/permissions"
    {access_token, params} = Map.pop(params, "access_token")

    with client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url, query: params) do
      {:ok, Enum.map(body, &from_response/1)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def get_permission!(params) do
    url = "/permissions/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Permission.query_changeset(%Permission{}, params),
          query = Changeset.apply_changes(changeset),
          client <- client(access_token),
          path_params = Map.take(query, [:id]),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url, opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def update_permission(params) do
    url = "/permissions/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Permission.changeset(%Permission{}, params),
         permission = changeset.changes,
         client <- client(access_token),
         path_params = Map.take(permission, [:id]),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.patch(client, url, %{"permission" => permission}, opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp from_response(response),
    do: %Permission{} |> Permission.changeset(response) |> Changeset.apply_changes()

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

  def get_types, do: @types
end
