defmodule BackendWeb.TaskView do
  use BackendWeb, :view
  alias BackendWeb.TaskView
  # alias BackendWeb.UserView

  def render("index.json", %{tasks: tasks}) do
    # %{data: render_many(tasks, TaskView, "task.json")}
    render_many(tasks, TaskView, "task.json")
  end

  def render("show.json", %{task: task}) do
    # %{data: render_one(task, TaskView, "task.json")}
    render_one(task, TaskView, "task.json")
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      title: task.title,
      position: task.position,
      is_deleted: task.is_deleted,
      board_id: task.board_id,
      # user_id: task.user_id,
      list_id: task.list_id,
      # created_by: render_one(task.user, UserView, "user.json", as: :user),
      inserted_at: NaiveDateTime.to_string(task.inserted_at),
      updated_at: NaiveDateTime.to_string(task.updated_at)}
  end
end
