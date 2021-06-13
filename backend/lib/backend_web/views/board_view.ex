defmodule BackendWeb.BoardView do
  use BackendWeb, :view
  alias BackendWeb.BoardView
  alias BackendWeb.UserView

  def render("index.json", %{boards: boards}) do
    %{data: render_many(boards, BoardView, "board.json")}
  end

  def render("show.json", %{board: board}) do
    %{data: render_one(board, BoardView, "board.json")}
  end

  def render("board.json", %{board: board}) do
    %{id: board.id,
      name: board.name,
      created_by: render_one(board.user, UserView, "user.json", as: :user),
      inserted_at: NaiveDateTime.to_string(board.inserted_at),
      updated_at: NaiveDateTime.to_string(board.updated_at)}
  end
end
