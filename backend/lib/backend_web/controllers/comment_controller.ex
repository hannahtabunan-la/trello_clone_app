defmodule BackendWeb.CommentController do
  use BackendWeb, :controller

  alias Backend.Comments
  alias Backend.Schemas.Comment

  action_fallback BackendWeb.FallbackController

  def index(conn, %{"task_id" => task_id}) do
    # TODO: Return error when task_id = nil
    # TODO: Return error when task_id = nil

    comments = Comments.list_comments_not_deleted(task_id)
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    comment_params = Map.put(comment_params, "user_id", conn.assigns.current_user.id)

    with {:ok, %Comment{} = comment} <- Comments.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.comment_path(conn, :show, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)
    with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    comment_params = %{"is_deleted" => true}

    with {:ok, %Comment{}} <- Comments.update_comment(comment, comment_params) do
      send_resp(conn, :no_content, "")
    end
  end
end
