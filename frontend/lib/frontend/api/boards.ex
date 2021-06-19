defmodule Frontend.API.Boards do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.Board
  alias Frontend.API.Boards

  @success_codes 200..399

  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  def create_board(params) do
    url = "/boards"

    with %{valid?: true} = changeset <- Board.changeset(%Board{}, params),
         board <- Changeset.apply_changes(changeset),
         client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, board) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def all_boards() do
    url = "/boards"

    with client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url) do
      {:ok, Enum.map(body, &from_response/1)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp from_response(response),
    do: %Board{} |> Board.changeset(response) |> Changeset.apply_changes()

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://localhost:4000/api"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
