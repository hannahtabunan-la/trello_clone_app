defmodule Frontend.API.Tasks do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.Task

  @success_codes 200..399

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def create_task(params) do
    IO.puts("+++++ LISTS_API_CREATE +++++")
    url = "/tasks"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Task.create_changeset(%Task{}, params),
         task <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, %{"task" => task}) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def all_tasks(params) do
    url = "/tasks"
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

  def get_task!(params) do
    url = "/tasks/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Task.query_changeset(%Task{}, params),
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

  def update_task(params) do
    url = "/tasks/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Task.changeset(%Task{}, params),
         task = changeset.changes,
         client <- client(access_token),
         path_params = Map.take(task, [:id]),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.patch(client, url, %{"task" => task}, opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp from_response(response),
    do: %Task{} |> Task.changeset(response) |> Changeset.apply_changes()

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
