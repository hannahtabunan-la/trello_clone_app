defmodule BackendWeb.BoardController do
  use BackendWeb, :controller

  alias Backend.Boards
  alias Backend.Schemas.Board
  alias Backend.Transactions.CreateBoard

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    boards = Boards.list_boards_based_on_permission(user_id)
    render(conn, "index.json", boards: boards)
  end

  def create(conn, %{"board" => board_params}) do
    user_id = conn.assigns.current_user.id
    board_params = Map.put(board_params, "user_id", user_id)

    with {:ok, %{:create_board => board}} <- CreateBoard.create(board_params),
         board <- Boards.get_board!(board.id, user_id) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.board_path(conn, :show, board))
          |> render("show.json", board: board)
    else
      {:error, changeset} -> {:error, changeset}
      {:error, error} -> {:error, error}
    end
  end

  def show(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    render(conn, "show.json", board: board)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{} = board} <- Boards.update_board(board, board_params) do
      render(conn, "show.json", board: board)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{}} <- Boards.delete_board(board) do
      send_resp(conn, :no_content, "")
    end
  end
end
