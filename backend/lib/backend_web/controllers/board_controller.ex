defmodule BackendWeb.BoardController do
  use BackendWeb, :controller

  alias Backend.Repo
  alias Backend.Boards
  alias Backend.Schemas.Board
  alias Backend.Transactions.CreateBoardWithPermission

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    boards = Boards.list_boards()
    render(conn, "index.json", boards: boards)
  end

  def create(conn, %{"board" => board_params}) do
    board_params = Map.put(board_params, "user_id", conn.assigns.current_user.id)

    with {:ok, %{:create_board => board}} <- Repo.transaction(CreateBoardWithPermission.create(board_params)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.board_path(conn, :show, board))
      |> render("show.json", board: board)
    end
  end

  def create_board() do

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
