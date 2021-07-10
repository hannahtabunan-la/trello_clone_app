defmodule Backend.Transactions.CreateBoard do
  alias Ecto.Multi

  alias Backend.Repo
  alias Backend.Boards
  alias Backend.Permissions
  alias Backend.Schemas.List

  def create(board) do
    Multi.new()
    |> Multi.run(:create_board, create_board(board))
    |> Multi.insert_all(:create_lists, List, &create_lists/1)
    |> Multi.run(:create_permission, &create_permission/2)
    |> Repo.transaction()
  end

  defp create_board(attrs \\ %{}) do
    fn repo, _ ->
      case Boards.create_board(attrs) do
        {:ok, board} -> {:ok, board}
        {:error, _board} -> {:error, :failed_create_board}
      end
    end
  end

  defp create_lists(%{create_board: board}) do
    lists = Enum.with_index(["pending", "in progress", "completed"], &(
      %{ title: &1, position: Decimal.new(&2) }
    ))

    lists
    |> Enum.map(fn list ->
      list
      |> Map.put(:board_id, board.id)
      |> Map.put(:user_id, board.user_id)
      |> Map.put(:inserted_at, NaiveDateTime.truncate(NaiveDateTime.utc_now, :second))
      |> Map.put(:updated_at, NaiveDateTime.truncate(NaiveDateTime.utc_now, :second))
    end)
  end

  defp create_permission(repo, %{create_board: board}) do
    %{user_id: user_id, id: board_id} = board

    permission = %{
      "type" => "manage",
      "user_id" => user_id,
      "board_id" => board_id
    }

    case Permissions.create_permission(permission) do
      {:ok, permission} -> {:ok, permission}
      {:error, _permission} -> {:error, :failed_create_permission}
    end
  end
end
