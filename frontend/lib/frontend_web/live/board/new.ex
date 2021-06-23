defmodule FrontendWeb.Live.Board.New do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.Schemas.Board
  alias Frontend.API.Boards

  def mount(_params, session, socket) do
    assigns = %{
      # access_token: session.access_token,
      # current_user: session.current_user,
      changeset: Board.create_changeset(%Board{}),
      csrf_token: session["csrf_token"],
      action: Routes.board_path(socket, :create),
      submit_handler: "create",
      submit_disble_message: "Creating"
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "form.html", assigns)


  def handle_event("create", %{"board" => board}, socket) do
    case Boards.create_board(board) do
      {:ok, board} ->
          {:noreply,
          socket
          |> put_flash(:info, "Board is successfully created.")
          |> redirect(to: Routes.board_path(socket, :show, board.id))}
      {:error, _board} ->
          {:noreply,
          socket
          |> put_flash(:error, "Failed to create board.")}
    end
  end
end