defmodule BackendWeb.PermissionController do
  use BackendWeb, :controller

  alias Backend.Permissions
  alias Backend.Schemas.Permission

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    permissions = Permissions.list_permissions()
    render(conn, "index.json", permissions: permissions)
  end

  def create(conn, %{"permission" => permission_params}) do
    with {:ok, %Permission{} = permission} <- Permissions.create_permission(permission_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.permission_path(conn, :show, permission))
      |> render("show.json", permission: permission)
    end
  end

  def show(conn, %{"id" => id}) do
    permission = Permissions.get_permission!(id)
    render(conn, "show.json", permission: permission)
  end

  def update(conn, %{"id" => id, "permission" => permission_params}) do
    permission = Permissions.get_permission!(id)

    with {:ok, %Permission{} = permission} <- Permissions.update_permission(permission, permission_params) do
      render(conn, "show.json", permission: permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = Permissions.get_permission!(id)

    with {:ok, %Permission{}} <- Permissions.delete_permission(permission) do
      send_resp(conn, :no_content, "")
    end
  end
end
