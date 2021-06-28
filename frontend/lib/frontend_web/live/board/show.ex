defmodule FrontendWeb.Live.Board.Show do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.Schemas.Board
  alias Frontend.API.Boards

  alias Frontend.Schemas.Task
  alias Frontend.API.Tasks

  @impl true
  def mount(_params, session, socket) do
    id = session["board"].id

    assigns = %{
      # access_token: session.access_token,
      # current_user: session.current_user,
      board: session["board"],
      csrf_token: session["token"],
      statuses: Boards.get_statuses(),
      changeset: Task.create_changeset(%Task{}, %{"board_id" => id})
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end
    socket = assign(socket, assigns)

    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    # access_token = socket.assigns.access_token
    # params = Map.put(params, "access_token", access_token)

    with {:ok, tasks} <- Tasks.all_tasks(socket.assigns.board.id) do
      tasks = tasks
      |> Enum.group_by(&Map.get(&1, :status))

      assigns = %{
        pending: tasks[:pending] || [],
        in_progress: tasks[:in_progress] || [],
        completed: tasks[:completed] || []
      }

      assign(socket, assigns)
    else
      _result -> socket
    end
  end

  defp fetch_task(socket, id) do
    # access_token = socket.assigns.access_token
    # params = Map.put(params, "access_token", access_token)

    with {:ok, task} <- Tasks.get_task!(%{"task_id" => id}) do
      task
    else
      _result -> []
    end
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "show_content.html", assigns)

  @impl true

  def handle_event("dropped", %{"draggedId" => dragged_id, "dropzoneId" => drop_zone_id,"draggableIndex" => draggable_index}, %{assigns: assigns} = socket) do
    drop_zone_atom = drop_zone_id |> get_drop_zone_atom
    dragged = find_dragged(assigns, dragged_id)

    case Tasks.update_task(dragged, %{status: drop_zone_id}, [:status]) do
        {:ok, _task} ->
            socket =
              [:pending, :in_progress, :completed]
              |> Enum.reduce(socket, fn zone_atom, %{assigns: assigns} = accumulator ->
                updated_list =
                  assigns
                  |> update_list(zone_atom, dragged, drop_zone_atom, draggable_index)
                accumulator
                  |> assign(zone_atom, updated_list)
              end)
            # {:noreply, socket}

            {:noreply,
            socket
            |> put_flash(:info, "Task is successfully updated.")}
        {:error, _task} ->
            {:noreply,
            socket
            |> put_flash(:error, "Failed to update task.")}
    end
  end

  defp get_drop_zone_atom(drop_zone_id) do
    case drop_zone_id in ["pending", "in_progress", "completed"] do
      true ->
        drop_zone_id |> String.to_existing_atom()
      false ->
        throw "invalid drop_zone_id"
    end
  end

  defp find_dragged(%{pending: pending, in_progress: in_progress, completed: completed}, dragged_id) do
    pending ++ in_progress
      |> Enum.find(nil, fn draggable ->
        {dragged_id, _string} = Integer.parse(dragged_id)
        draggable.id == dragged_id
      end)
  end

  def update_list(assigns, list_atom, dragged, drop_zone_atom, draggable_index) when list_atom == drop_zone_atom  do
    assigns[list_atom]
    |> remove_dragged(dragged.id)
    |> List.insert_at(draggable_index, dragged)
  end

  def update_list(assigns, list_atom, dragged, drop_zone_atom, draggable_index) when list_atom != drop_zone_atom  do
    assigns[list_atom]
    |> remove_dragged(dragged.id)
  end

  def remove_dragged(list, dragged_id) do
    list
    |> Enum.filter(fn draggable ->
      draggable.id != dragged_id
    end)
  end

  def handle_event("create", %{"task" => task}, socket) do
    id = socket.assigns.board.id
    task = Map.put(task, "board_id", id)

    case Tasks.create_task(task) do
      {:ok, _task} ->
          socket = fetch(socket)
          {:noreply,
          socket
          |> put_flash(:info, "Task is successfully created.")}
      {:error, _task} ->
          {:noreply,
          socket
          |> put_flash(:error, "Failed to create task.")}
    end
  end
end
