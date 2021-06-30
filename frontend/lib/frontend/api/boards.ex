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
    IO.puts("+++++ BOARDS_API_CREATE +++++")
    url = "/boards"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Board.create_changeset(%Board{}, params),
         board <- Changeset.apply_changes(changeset),
         client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.post(client, url, %{"board" => board}) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def all_boards(params) do
    url = "/boards"
    {access_token, _params} = Map.pop(params, "access_token")

    with client <- client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url) do
      {:ok, Enum.map(body, &from_response/1)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def get_board!(params) do
    url = "/boards/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Board.query_changeset(%Board{}, params),
          query = Changeset.apply_changes(changeset),
          client <- client(access_token),
          path_params = Map.take(query, [:id]),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.get(client, url, opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def update_board(params) do
    url = "/boards/:id"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Board.changeset(%Board{}, params),
         board = changeset.changes,
         client <- client(access_token),
         path_params = Map.take(board, [:id]),
         {:ok, %{body: body, status: status}} when status in @success_codes
          <- Tesla.patch(client, url, %{"board" => board}, opts: [path_params: path_params]) do
      {:ok, from_response(body)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp from_response(response),
    do: %Board{} |> Board.changeset(response) |> Changeset.apply_changes()

  def client(access_token) do
    url = Application.get_env(:frontend, :api_url)

    middleware = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{access_token}"}]},
    ]

    Tesla.client(middleware)
  end

  def get_statuses, do: @statuses
end
