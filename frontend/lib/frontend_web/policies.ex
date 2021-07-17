defmodule FrontendWeb.Policies do
  use PolicyWonk.Policy         # set up support for policies
  use PolicyWonk.Enforce        # turn this module into an enforcement plug

  alias FrontendWeb.ErrorHandler

  alias FrontendWeb.Policies.BoardPolicies
  alias Frontend.Schemas.User

  def policy(assigns, :current_user) do
    case assigns[:current_user] do
      _user = %User{} -> :ok
      _ ->    :current_user
    end
  end

  def policy(assigns, identifier)
      when identifier in [
        :board_view,
        :board_edit,
        :board_list_actions,
        :board_task_actions,
        :board_task_assign,
        :board_comment
      ],
      do: BoardPolicies.policy(assigns, identifier)

  def policy_error(conn, :current_user) do
    FrontendWeb.ErrorHandlers.unauthenticated(conn, "Must be logged in")
  end

  def policy_error(conn, error_code), do: ErrorHandler.policy_error(conn, error_code)
end
