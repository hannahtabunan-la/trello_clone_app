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
      action: Routes.board_path(socket, :create)
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "form.html", assigns)


  def handle_event("create", %{"board" => board}, socket) do
    IO.puts("+++++ HANDLE_EVENT CREATE +++++")

    case Boards.create_board(board) do
      {:ok, _board} ->
          {:noreply,
          socket
          |> put_flash(:info, "Board is successfully created.")}
          |> redirect(to: Routes.board_response_path(socket, :show, board))
      {:error, _board} ->
          {:noreply,
          socket
          |> put_flash(:error, "Failed to create board.")}
    end
  end
end
