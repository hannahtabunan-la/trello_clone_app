defmodule FrontendWeb.Live.Board.List.Index do
  use FrontendWeb, :live_view

  alias Frontend.API.Lists

  def mount(_params, session, socket) do
    assigns = %{
      access_token: session["access_token"],
      # current_user: session.current_user,
      board: session["board"],
      csrf_token: session["csrf_token"],
      view: :list,
      modal: nil
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    if connected?(socket) do


      # Phoenix.PubSub.subscribe(Frontend.PubSub, "list")
    end

    fetch(assign(socket, assigns))
  end

  defp fetch(socket) do
    board_id = socket.assigns.board.id
    access_token = socket.assigns.access_token
    params = %{access_token: access_token, board_id: board_id}

    case Lists.all_lists(params) do
      {:ok, lists} ->
        IO.inspect(lists)
        {:ok, assign(socket, lists: lists)}
      {:error, _lists} ->
        {:ok, socket |> put_flash(:error, "Failed to fetch lists.")}
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
        Phoenix.PubSub.broadcast(Frontend.PubSub, "list:#{id}", {"list:#{id}", "update_list", payload: %{list: list}})

        {:noreply,
        socket
        |> put_flash(:info, "List position updated successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
