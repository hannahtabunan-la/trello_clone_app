defmodule FrontendWeb.Live.Board.List.Index do
  use FrontendWeb, :live_view

  alias Frontend.API.Lists
  alias Frontend.API.Tasks

  def mount(_params, session, socket) do
    assigns = %{
      access_token: session["access_token"],
      current_user: session["current_user"],
      permissions: session["permissions"],
      board: session["board"],
      csrf_token: session["csrf_token"],
      view: :list,
      modal: nil,
      list_id: nil,
      list: nil,
      task_id: nil
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Frontend.PubSub, "list")
      Phoenix.PubSub.subscribe(Frontend.PubSub, "task")
    end

    socket = fetch_lists(assign(socket, assigns))

    {:ok, fetch_tasks(assign(socket, assigns))}
  end

  defp fetch_lists(socket) do
    board_id = socket.assigns.board.id
    access_token = socket.assigns.access_token
    params = %{"access_token" => access_token, "board_id" => board_id}

    case Lists.all_lists(params) do
      {:ok, lists} -> assign(socket, lists: lists)
      {:error, _lists} -> socket |> put_flash(:error, "Failed to fetch lists.")
    end
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.ListView, "index.html", assigns)

  @impl true
  def handle_event("dropped", %{"draggedId" => dragged_id,"draggableIndex" => draggable_index}, %{assigns: assigns} = socket) do
    IO.inspect(dragged_id)
  end

  def handle_event("reorder", %{"id" => id, "position" => position }, socket) do
    IO.puts("HANDLE EVENT REORDER")

    access_token = socket.assigns.access_token
    params = %{
      "access_token" => access_token,
      "id" => id,
      "position" => position

    }

    case Lists.update_list(params) do
      {:ok, list} ->
        Phoenix.PubSub.broadcast(Frontend.PubSub, "list", {"list", "update", payload: %{list: list}})

        {:noreply,
        socket
        |> put_flash(:info, "List position updated successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("edit_list", %{"id" => id}, socket) do
    assigns = %{
      modal: :edit,
      list_id: id
    }

    {:noreply, assign(socket, assigns)}

    # fetch(assign(socket, assigns))
  end

  def fetch(socket) do
    id = socket.assigns.list_id
    access_token = socket.assigns.access_token
    params = %{access_token: access_token, id: id}

    case Lists.get_list!(params) do
      {:ok, list} ->
        IO.inspect(list)
        {:noreply, assign(socket, list: list)}
      {:error, _lists} ->
        {:noreply, socket |> put_flash(:error, "Failed to fetch list.")}
    end
  end

  def handle_info({_subject, "update", payload: %{list: _list}}, socket) do
    # changeset = Board.update_changeset(list)
    # test = Enum.find(socket.assigns.lists)
    socket = assign(socket, modal: nil)
    {:noreply, fetch_lists(socket)}
  end

  def handle_info({_event, "close_modal", _data}, socket) do
    {:noreply, assign(socket, modal: nil)}
  end

  def handle_info({_subject, "create", payload: %{list: _list}}, socket) do
    # changeset = Board.update_changeset(list)
    # test = Enum.find(socket.assigns.lists)

    {:noreply, fetch_lists(socket)}
  end

  def handle_info({_subject, "create_task", payload: %{task: _task}}, socket) do
    # changeset = Board.update_changeset(list)
    # test = Enum.find(socket.assigns.lists)
    socket = assign(socket, list_id: nil)
    {:noreply, fetch_tasks(socket)}
  end

  def handle_info({_subject, "update_task", payload: %{task: _task}}, socket) do
    # changeset = Board.update_changeset(list)
    # test = Enum.find(socket.assigns.lists)

    assigns = %{
      task_id: nil,
      modal: nil
    }

    {:noreply, fetch_tasks(assign(socket, assigns))}
  end

  def fetch_tasks(socket) do
    board_id = socket.assigns.board.id
    access_token = socket.assigns.access_token
    params = %{"access_token" => access_token, "board_id" => board_id}

    case Tasks.all_tasks(params) do
      {:ok, tasks} ->
        tasks = tasks
        |> Enum.group_by(&Map.get(&1, :list_id))

        assign(socket, tasks: tasks)
      {:error, _lists} -> socket |> put_flash(:error, "Failed to fetch lists.")
    end
  end

  def handle_event("card_dropped", %{"draggedId" => card_id, "dropzoneId" => list_id}, socket) do
    access_token = socket.assigns.access_token

    params = %{
      "id"=> card_id,
      "list_id" => list_id,
      "access_token" => access_token
    }

    case Tasks.update_task(params) do
        {:ok, task} ->
            {:noreply,
            fetch_tasks(socket)
            |> put_flash(:info, "Task is successfully updated.")}
        {:error, _task} ->
            {:noreply,
            socket
            |> put_flash(:error, "Failed to update task.")}
    end

    {:noreply, socket}
  end

  def handle_event("new_task", %{"list" => list_id}, socket) do
    assigns = %{
      modal: :new_task,
      list_id: list_id
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("edit_task", %{"id" => id}, socket) do
    assigns = %{
      task_id: id,
      modal: :edit_task
    }

    {:noreply, assign(socket, assigns)}
  end
end
