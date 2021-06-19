defmodule Backend.Transactions.CreateBoardWithPermission do
  alias Ecto.Multi

  alias Backend.Boards
  alias Backend.Permissions

  def create(board) do
    Multi.new()
    |> Multi.run(:create_board, create_board(board))
    |> Multi.run(:create_permission, &create_permission/2)
  end

  defp create_board(attrs \\ %{}) do
    fn repo, _ ->
      case Boards.create_board(attrs) do
        {:ok, board} -> {:ok, board}
        {:error, _board} -> {:error, :failed_create_board}
      end
    end
  end

  defp create_permission(repo, %{create_board: board}) do
    %{user_id: user_id, id: board_id} = board

    permission = %{
      "type" => "write",
      "user_id" => user_id,
      "board_id" => board_id
    }

    case Permissions.create_permission(permission) do
      {:ok, permission} -> {:ok, permission}
      {:error, _permission} -> {:error, :failed_create_permission}
    end
  end
end
