defmodule FrontendWeb.Loaders.PermissionLoaders do
  alias Frontend.API.Permissions

  def resource(%{assigns: %{access_token: access_token}}, :permissions, %{"id" => board_id}) do
    case Permissions.all_permissions(%{"access_token" => access_token, "board_id" => board_id}) do
      {:ok, permissions} -> {:ok, :permissions, permissions}
      {:error, message} ->
        {:error, message}
    end
  end
end
