defmodule BackendWeb.PermissionView do
  use BackendWeb, :view
  alias BackendWeb.PermissionView
  # alias BackendWeb.UserView
  # alias BackendWeb.BoardView

  def render("index.json", %{permissions: permissions}) do
    # %{data: render_many(permissions, PermissionView, "permission.json")}
    render_many(permissions, PermissionView, "permission.json")
  end

  def render("show.json", %{permission: permission}) do
    # %{data: render_one(permission, PermissionView, "permission.json")}
    render_one(permission, PermissionView, "permission.json")
  end

  def render("permission.json", %{permission: permission}) do
    %{id: permission.id,
      type: permission.type,
      user_id: permission.user_id,
      board_id: permission.board_id
      # user: render_one(permission.user, UserView, "user.json", as: :user),
      # board: render_one(permission.board, BoardView, "board.json", as: :board),
    }
  end
end
