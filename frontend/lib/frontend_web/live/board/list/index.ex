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
      modal_list: nil,
      list_id: nil,
      list: nil
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Frontend.PubSub, "list")
    end

    fetch_list(assign(socket, assigns))
  end

  defp fetch_list(socket) do
    board_id = socket.assigns.board.id
    access_token = socket.assigns.access_token
    params = %{access_token: access_token, board_id: board_id}

    case Lists.all_lists(params) do
      {:ok, lists} ->
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
        Phoenix.PubSub.broadcast(Frontend.PubSub, "list", {"list", "update_list", payload: %{list: list}})

        {:noreply,
        socket
        |> put_flash(:info, "List position updated successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("edit_list", %{"id" => id}, socket) do
    assigns = %{
      modal_list: :edit,
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
        IO.puts("LIIIIIST")
        {:noreply, socket |> put_flash(:error, "Failed to fetch list.")}
    end
  end

  def handle_info({_subject, "update_list", payload: %{list: _list}}, socket) do
    # changeset = Board.update_changeset(list)
    {:noreply, assign(socket, modal: nil)}
  end

  def handle_info({_event, "close_modal", _data}, socket) do
    {:noreply, assign(socket, modal: nil)}
  end
end
