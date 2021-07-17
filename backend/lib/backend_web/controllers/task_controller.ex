defmodule BackendWeb.TaskController do
  use BackendWeb, :controller

  alias Backend.Tasks
  alias Backend.Schemas.Task

  action_fallback BackendWeb.FallbackController

  def index(conn, %{"board_id" => board_id}) do
    # TODO: Return error when board_id = nil
    # TODO: Return error when board_id = nil

    tasks = Tasks.list_tasks_not_deleted(board_id)
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    new_position = case Tasks.get_last_position() do
      nil ->
        "1.0"
      %{ position: last_position } ->
          Decimal.add(last_position, "1.0")
    end

    task_params = Map.put(task_params, "position", new_position)
    task_params = Map.put(task_params, "user_id", conn.assigns.current_user.id)

    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)
    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    task_params = %{"is_deleted" => true}

    with {:ok, %Task{}} <- Tasks.update_task(task, task_params) do
      send_resp(conn, :no_content, "")
    end
  end
end
