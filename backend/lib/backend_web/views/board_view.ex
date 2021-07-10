defmodule BackendWeb.BoardView do
  use BackendWeb, :view
  alias BackendWeb.BoardView
  # alias BackendWeb.UserView

  def render("index.json", %{boards: boards}) do
    render_many(boards, BoardView, "board.json")
  end

  def render("show.json", %{board: board}) do
    render_one(board, BoardView, "board.json")
  end

  def render("board.json", %{board: board}) do
    %{id: board.id,
      name: board.name,
      user_id: board.user_id,
      # created_by: render_one(board.user, UserView, "user.json", as: :user),
      permission: get_permission(board.permissions),
      inserted_at: NaiveDateTime.to_string(board.inserted_at),
      updated_at: NaiveDateTime.to_string(board.updated_at)}
  end

  defp get_permission(permissions) do
    %{type: type} = List.first(permissions)
    type
  end
end
