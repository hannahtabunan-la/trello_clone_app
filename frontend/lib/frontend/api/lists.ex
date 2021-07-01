defmodule Frontend.API.Lists do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.List

  @success_codes 200..399
  @statuses [
    :pending,
    :in_progress,
    :completed
  ]

  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  def create_list(params) do
    IO.puts("+++++ LISTS_API_CREATE +++++")
    url = "/lists"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- List.create_changeset(%List{}, params),
         list <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, %{"list" => list}) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def all_lists(params) do
    url = "/lists"
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

  def get_list!(params) do
    url = "/lists/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- List.query_changeset(%List{}, params),
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

  def update_list(params) do
    url = "/lists/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- List.changeset(%List{}, params),
         list = changeset.changes,
         client <- client(access_token),
         path_params = Map.take(list, [:id]),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.patch(client, url, %{"list" => list}, opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp from_response(response),
    do: %List{} |> List.changeset(response) |> Changeset.apply_changes()

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

  def get_statuses, do: @statuses
end
