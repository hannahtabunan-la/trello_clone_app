defmodule Frontend.API.Tasks do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.Task

  @success_codes 200..399
  @statuses [
    :pending,
    :in_progress,
    :completed
  ]

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def create_task(params) do
    IO.puts("+++++ TASKS_API CREATE +++++")
    url = "/tasks"

    with %{valid?: true} = changeset <- Task.changeset(%Task{}, params),
         task <- Changeset.apply_changes(changeset),
         client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, %{"task" => task}) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def all_tasks(), do: {:error, "Board ID is required."}

  def all_tasks(board_id) do
    url = "/tasks"

    with client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url, query: [board_id: board_id]) do
      {:ok, Enum.map(body, &from_response/1)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def get_task!(%{"task_id" => id}) do
    url = "/tasks/:id"
    params = [id: id]

    with client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url, opts: [path_params: params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def update_task(task, params, attrs \\ nil) do
    url = "/tasks/:id"
    attrs = attrs || Task.update_attrs()
    id = task.id

    with %{valid?: true} = changeset <- Task.update_changeset(task, params, attrs),
         task <- changeset.changes,
         client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.patch(client, url, %{"task" => task}, opts: [path_params: [id: id]]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp from_response(response),
    do: %Task{} |> Task.changeset(response) |> Changeset.apply_changes()

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://localhost:4000/api"},
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams
    ]

    Tesla.client(middleware)
  end

  def get_statuses, do: @statuses
end
