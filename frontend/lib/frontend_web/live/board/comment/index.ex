defmodule FrontendWeb.Live.Board.Comment.Index do
  use FrontendWeb, :live_view

  alias Frontend.API.Comments
  alias Frontend.Schemas.Comment

  def mount(_params, session, socket) do
    assigns = %{
      access_token: session["access_token"],
      current_user: session["current_user"],
      permissions: session["permissions"],
      csrf_token: session["csrf_token"],
      task_id: session["task_id"],
      changeset: Comment.create_changeset(%Comment{}),
      comments: []
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    # if connected?(socket) do
    #   Phoenix.PubSub.subscribe(Frontend.PubSub, "list")
    #   Phoenix.PubSub.subscribe(Frontend.PubSub, "task")
    # end

    {:ok, fetch_comments(assign(socket, assigns))}
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.CommentView, "index.html", assigns)

  defp fetch_comments(%{assigns: assigns} = socket) do
    task_id = assigns.task_id
    access_token = socket.assigns.access_token
    params = %{"access_token" => access_token, "task_id" => task_id}

    case Comments.all_comments(params) do
      {:ok, comments} ->
        IO.inspect(comments)

        assigns = %{ comments: comments }

        assign(socket, assigns)
      {:error, _comments} -> socket |> put_flash(:error, "Failed to fetch comments.")
    end
  end

  def handle_event("create", %{"comment" => params}, socket) do
    access_token = socket.assigns.access_token
    params = Map.put(params, "access_token", access_token)

    case Comments.create_comment(params) do
      {:ok, _comment} ->
        assign(socket, changeset: Comment.create_changeset(%Comment{}))

        socket
        |> put_flash(:info, "Comment created successfully.")
        |> assign(changeset: Comment.create_changeset(%Comment{}))

        {:noreply, fetch_comments(socket)}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
