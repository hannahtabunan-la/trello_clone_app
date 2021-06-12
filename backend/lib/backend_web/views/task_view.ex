defmodule BackendWeb.TaskView do
  use BackendWeb, :view
  alias BackendWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      title: task.title,
      status: task.status,
      position: task.position,
      is_deleted: task.is_deleted}
  end
end
