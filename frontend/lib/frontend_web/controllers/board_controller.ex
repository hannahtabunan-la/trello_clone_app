defmodule FrontendWeb.BoardController do
  use FrontendWeb, :controller

  alias Frontend.Schemas.Board
  alias Frontend.API.Boards

  action_fallback FrontendWeb.FallbackController

  plug(Loaders, :permissions when action in [:show])

  plug(Policies, :board_view when action in [:show])

  def index(conn, params) do
    access_token = conn.private.plug_session["access_token"]
    params = Map.put(params, "access_token", access_token)

    with {:ok, boards} <- Boards.all_boards(params) do
      changeset = Boards.change_board(%Board{})

      render(conn, "index.html", boards: boards, token: get_csrf_token(), changeset: changeset, access_token: access_token)
    end
  end

  def new(conn, _params) do
    access_token = conn.private.plug_session["access_token"]

    changeset = Boards.change_board(%Board{})
    render(conn, "new.html", changeset: changeset, token: get_csrf_token(), access_token: access_token)
  end

  def create(conn, params) do
    params = Map.put(params, "access_token", conn.private.plug_session["token"])

    case Boards.create_board(params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board created successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    access_token = conn.private.plug_session["access_token"]
    params = Map.put(params, "access_token", access_token)

    case Boards.get_board!(params) do
      {:ok, board} ->
        render(conn, "show.html", board: board, token: get_csrf_token(), access_token: access_token)
      {:error, _error} ->
        conn
        |> put_flash(:error, "Board does not exist.")
        |> redirect(to: Routes.board_path(conn, :index))
    end
  end

  def edit(conn, params) do
    access_token = conn.private.plug_session["access_token"]
    params = Map.put(params, "access_token", access_token)

    case Boards.get_board!(params) do
      {:ok, board} ->
        changeset = Boards.change_board(board)
        render(conn, "edit.html", board: board, changeset: changeset, token: get_csrf_token(), access_token: access_token)
      {:error, _error} ->
        conn
        |> put_flash(:error, "Board does not exist.")
        |> redirect(to: Routes.board_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "board" => params}) do
    board = Boards.get_board!(id)

    case Boards.update_board(id, params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board updated successfully.")
        |> redirect(to: Routes.board_path(conn, :show, id))

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
