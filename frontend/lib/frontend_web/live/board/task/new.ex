defmodule FrontendWeb.Live.Board.Task.New do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.API.Tasks
  alias Frontend.Schemas.Task

  def mount(_params, session, socket) do
    IO.puts("LIST ID")
    IO.inspect(session["list_id"])

    assigns = %{
      access_token: session["access_token"],
      current_user: session["current_user"],
      permissions: session["permissions"],
      board_id: session["board_id"],
      list_id: session["list_id"],
      csrf_token: session["csrf_token"],
      submit_handler: "create",
      submit_disble_message: "Creating",
      changeset: Task.create_changeset(%Task{})
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}

  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.TaskView, "new_modal.html", assigns)

  def handle_event("create", %{"task" => params}, socket) do
    access_token = socket.assigns.access_token
    params = Map.put(params, "access_token", access_token)

    case Tasks.create_task(params) do
      {:ok, task} ->
        Phoenix.PubSub.broadcast(Frontend.PubSub, "task", {"task", "create_task", payload: %{task: task}})

        assign(socket, changeset: Task.create_changeset(%Task{}))

        {:noreply,
        socket
        |> put_flash(:info, "Task created successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("close_modal", _param, socket) do
    Phoenix.PubSub.broadcast(Frontend.PubSub, "list", {nil, "close_modal", nil})

    {:noreply, assign(socket, modal: nil)}
  end
end
