defmodule FrontendWeb.TaskController do
  use FrontendWeb, :controller

  alias Frontend.Schemas.Task
  alias Frontend.API.Tasks

  def index(conn, _params) do
    with {:ok, tasks} <- Tasks.all_tasks() do
      changeset = Tasks.change_board(%Task{})
      render(conn, "index.html", tasks: tasks, changeset: changeset)
    end
  end
end
