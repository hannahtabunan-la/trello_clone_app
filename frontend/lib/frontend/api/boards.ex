defmodule Frontend.API.Boards do
  use Tesla

  alias Ecto.Changeset

  alias Frontend.Schemas.Board

  @success_codes 200..399
  @statuses [
    :pending,
    :in_progress,
    :completed
  ]

  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  def create_board(params) do
    IO.puts("+++++ BOARDS_API CREATE +++++")
    url = "/boards"

    with %{valid?: true} = changeset <- Board.changeset(%Board{}, params),
         board <- Changeset.apply_changes(changeset),
         client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, %{"board" => board}) do
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

  def get_board!(%{"board_id" => id}) do
    url = "/boards/:id"
    params = [id: id]

    with client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url, opts: [path_params: params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def update_board(id, params) do
    url = "/boards/:id"

    with %{valid?: true} = changeset <- Board.changeset(%Board{}, params),
         board <- Changeset.apply_changes(changeset),
         client <- client(),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.patch(client, url, %{"board" => board}, opts: [path_params: [id: id]]) do
      {:ok, from_response(body)}
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
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams
    ]

    Tesla.client(middleware)
  end

  def get_statuses, do: @statuses
end
