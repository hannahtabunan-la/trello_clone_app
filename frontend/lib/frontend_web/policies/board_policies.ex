defmodule FrontendWeb.Policies.BoardPolicies do


  def policy(assigns, :board_view) do
    current_user = assigns.current_user
    permissions = assigns.permissions
    types = [:manage, :write, :read]

    case Enum.find(permissions, &(Enum.member?(types, &1.type) && &1.user_id == current_user.id)) do
      nil -> {:error, :forbidden}
      _ -> :ok
    end
  end

  def policy(assigns, :board_edit) do
    current_user = assigns.current_user
    permissions = assigns.permissions
    types = [:manage]

    case Enum.find(permissions, &(Enum.member?(types, &1.type) && &1.user_id == current_user.id)) do
      nil -> {:error, :forbidden}
      _ -> :ok
    end
  end

  def policy(assigns, :board_list_actions) do
    current_user = assigns.current_user
    permissions = assigns.permissions
    types = [:manage, :write]

    case Enum.find(permissions, &(Enum.member?(types, &1.type) && &1.user_id == current_user.id)) do
      nil -> {:error, :forbidden}
      _ -> :ok
    end
  end

  def policy(assigns, :board_task_actions) do
    current_user = assigns.current_user
    permissions = assigns.permissions
    types = [:manage, :write]

    case Enum.find(permissions, &(Enum.member?(types, &1.type) && &1.user_id == current_user.id)) do
      nil -> {:error, :forbidden}
      _ -> :ok
    end
  end

  def policy(assigns, :board_task_assign) do
    current_user = assigns.current_user
    permissions = assigns.permissions
    types = [:manage, :write]

    case Enum.find(permissions, &(Enum.member?(types, &1.type) && &1.user_id == current_user.id)) do
      nil -> {:error, :forbidden}
      _ -> :ok
    end
  end

  def policy(assigns, :board_comment) do
    current_user = assigns.current_user
    permissions = assigns.permissions
    types = [:manage, :write, :read]

    case Enum.find(permissions, &(Enum.member?(types, &1.type) && &1.user_id == current_user.id)) do
      nil -> {:error, :forbidden}
      _ -> :ok
    end
  end
end
