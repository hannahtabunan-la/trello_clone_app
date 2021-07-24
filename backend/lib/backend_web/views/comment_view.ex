defmodule BackendWeb.CommentView do
  use BackendWeb, :view
  alias BackendWeb.CommentView
  alias BackendWeb.UserView

  def render("index.json", %{comments: comments}) do
    # %{data: render_many(comment, CommentView, "comment.json")}
    render_many(comments, CommentView, "comment.json")
  end

  def render("show.json", %{comment: comment}) do
    # %{data: render_one(comment, CommentView, "comment.json")}
    render_one(comment, CommentView, "comment.json")
  end

  def render("comment.json", %{comment: comment}) do
    IO.inspect(comment)

    %{id: comment.id,
      comment: comment.comment,
      is_deleted: comment.is_deleted,
      task_id: comment.task_id,
      user_id: comment.user_id,
      inserted_at: NaiveDateTime.to_string(comment.inserted_at),
      updated_at: NaiveDateTime.to_string(comment.updated_at),
      created_by: render_one(comment.user, UserView, "user.json", as: :user)}
  end
end
