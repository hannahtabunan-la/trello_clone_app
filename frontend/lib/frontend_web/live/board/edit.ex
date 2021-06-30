defmodule FrontendWeb.Live.Board.Edit do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.API.Boards

  def mount(_params, session, socket) do
    changeset = Boards.change_board(session["board"])

    assigns = %{
      access_token: session["access_token"],
      # current_user: session.current_user,
      board: session["board"],
      changeset: changeset,
      csrf_token: session["csrf_token"],
      submit_handler: "update",
      submit_disble_message: "Updating"
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "edit_modal.html", assigns)

  def handle_event("update", %{"board" => params}, socket) do
    IO.puts("HANDLE EVENT PUTS")

    id = socket.assigns.board.id
    access_token = socket.assigns.access_token
    params = Map.put(params, "id", id)
    params = Map.put(params, "access_token", access_token)

    case Boards.update_board(params) do
      {:ok, board} ->
        Phoenix.PubSub.broadcast(Frontend.PubSub, "board:#{id}", {"board:#{id}", "update_board", payload: %{board: board}})

        {:noreply,
        socket
        |> put_flash(:info, "Board updated successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("close_modal", _param, socket) do
    id = socket.assigns.board.id
    Phoenix.PubSub.broadcast(Frontend.PubSub, "board:#{id}", {nil, "close_modal", nil})

    {:noreply, assign(socket, modal: nil)}
  end
end
