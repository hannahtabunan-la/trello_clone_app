defmodule BackendWeb.ListController do
  use BackendWeb, :controller

  alias Backend.Lists
  alias Backend.Schemas.List

  action_fallback BackendWeb.FallbackController

  def index(conn, %{"board_id" => board_id}) do
    lists = Lists.list_lists(board_id)
    render(conn, "index.json", lists: lists)
  end

  def create(conn, %{"list" => list_params}) do
    %{ "board_id" => board_id } = list_params

    new_position = case Lists.last_position(board_id) do
      nil ->
          "1.0";
      %{ position: last_position } ->
          Decimal.add(last_position, "1.0")
    end

    list_params = Map.put(list_params, "user_id", conn.assigns.current_user.id)
    list_params = Map.put(list_params, "position", new_position)

    with {:ok, %List{} = list} <- Lists.create_list(list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_path(conn, :show, list))
      |> render("show.json", list: list)
    end
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    render(conn, "show.json", list: list)
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list!(id)

    with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
      render(conn, "show.json", list: list)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)

    with {:ok, %List{}} <- Lists.delete_list(list) do
      send_resp(conn, :no_content, "")
    end
  end
end
