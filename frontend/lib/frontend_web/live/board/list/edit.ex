defmodule FrontendWeb.Live.Board.List.Edit do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.API.Lists

  def mount(_params, session, socket) do
    # IO.inspect(session["list"])

    # changeset = Lists.change_list(session["list"])

    assigns = %{
      access_token: session["access_token"],
      # current_user: session.current_user,
      # board: session["board"],
      list_id: session["list_id"],
      csrf_token: session["csrf_token"],
      submit_handler: "update",
      submit_disble_message: "Updating",
      # changeset: changeset
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    # IO.inspect(session["changeset"])

    # {:ok, assign(socket, assigns)}
    fetch(assign(socket, assigns))
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.ListView, "edit_modal.html", assigns)

  def handle_event("update", %{"board" => params}, socket) do
    IO.puts("HANDLE EVENT PUTS")

    id = socket.assigns.board.id
    access_token = socket.assigns.access_token
    params = Map.put(params, "id", id)
    params = Map.put(params, "access_token", access_token)

    case Lists.update_list(params) do
      {:ok, list} ->
        Phoenix.PubSub.broadcast(Frontend.PubSub, "list", {"list", "update_list", payload: %{list: list}})

        {:noreply,
        socket
        |> put_flash(:info, "Board updated successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("close_modal", _param, socket) do
    # id = socket.assigns.list.id
    Phoenix.PubSub.broadcast(Frontend.PubSub, "list", {nil, "close_modal", nil})

    {:noreply, assign(socket, modal: nil)}
  end

  def fetch(socket) do
    id = socket.assigns.list_id
    access_token = socket.assigns.access_token
    params = %{access_token: access_token, id: id}

    case Lists.get_list!(params) do
      {:ok, list} ->
        changeset = Lists.change_list(list)

        assigns = %{
          list: list,
          changeset: changeset
        }

        {:ok, assign(socket, assigns)}
      {:error, _lists} ->
        {:ok, socket |> put_flash(:error, "Failed to fetch list.")}
    end
  end
end
