defmodule FrontendWeb.BoardController do
  use FrontendWeb, :controller

  alias Frontend.Schemas.Board
  alias Frontend.API.Boards

  def index(conn, _params) do
    with {:ok, boards} <- Boards.all_boards() do
      changeset = Boards.change_board(%Board{})
      render(conn, "index.html", boards: boards, changeset: changeset)
    end
  end

  def new(conn, _params) do
    changeset = Boards.change_board(%Board{})
    render(conn, "new.html", changeset: changeset, token: get_csrf_token())
  end

  def create(conn, %{"board" => board_params}) do
    case Boards.create_board(board_params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board created successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Boards.get_board!(%{"board_id" => id}) do
      {:ok, board} ->
        render(conn, "show.html", board: board)
      {:error, _error} ->
        conn
        |> put_flash(:error, "Board does not exist.")
        |> redirect(to: Routes.board_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    changeset = Boards.change_board(board)
    render(conn, "edit.html", board: board, changeset: changeset)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Boards.get_board!(id)

    case Boards.update_board(board, board_params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board updated successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board: board, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    {:ok, _board} = Boards.delete_board(board)

    conn
    |> put_flash(:info, "Board deleted successfully.")
    |> redirect(to: Routes.board_path(conn, :index))
  end
end
