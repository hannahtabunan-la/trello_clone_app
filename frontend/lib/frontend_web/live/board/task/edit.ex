defmodule FrontendWeb.Live.Board.Task.Edit do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.API.Tasks
  alias Frontend.Schemas.Task

  def mount(_params, session, socket) do
    IO.puts("TASK ID")
    IO.inspect(session["id"])

    assigns = %{
      access_token: session["access_token"],
      # current_user: session.current_user,
      csrf_token: session["csrf_token"],
      id: session["id"],
      submit_handler: "update",
      submit_disble_message: "Updating"
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, fetch(assign(socket, assigns))}

  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.TaskView, "edit_modal.html", assigns)

  def handle_event("update", %{"task" => params}, socket) do
    access_token = socket.assigns.access_token
    params = Map.put(params, "access_token", access_token)

    case Tasks.update_task(params) do
      {:ok, task} ->
        Phoenix.PubSub.broadcast(Frontend.PubSub, "task", {"task", "update_task", payload: %{task: task}})

        assign(socket, changeset: Task.create_changeset(%Task{}))

        {:noreply,
        socket
        |> put_flash(:info, "Task updated successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def fetch(socket) do
    id = socket.assigns.id
    access_token = socket.assigns.access_token
    params = %{"access_token" => access_token, "id" => id}

    case Tasks.get_task!(params) do
      {:ok, task} ->
        changeset = Tasks.change_task(task)

        assigns = %{
          task: task,
          changeset: changeset
        }

        assign(socket, assigns)
      {:error, _lists} -> socket |> put_flash(:error, "Failed to fetch task.")
    end
  end

  def handle_event("close_modal", _param, socket) do
    Phoenix.PubSub.broadcast(Frontend.PubSub, "list", {nil, "close_modal", nil})

    {:noreply, assign(socket, modal: nil)}
  end
end
