defmodule FrontendWeb.Policies.BoardPolicies do


  def policy(assigns, :board_view) do
    current_user = assigns.current_user
    permissions = assigns.permissions
    types = [:manage, :write, :read]

    case Enum.find(permissions, &(Enum.member?(types, &1.type) && &1.user_id == current_user.id)) do
      nil ->
        IO.puts("NO PERMISSION")
        {:error, :forbidden}
      _ -> :ok
    end
  end
end
