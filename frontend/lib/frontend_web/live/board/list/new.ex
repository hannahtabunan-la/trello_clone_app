defmodule FrontendWeb.Live.Board.List.New do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.API.Lists
  alias Frontend.Schemas.List

  def mount(_params, session, socket) do
    assigns = %{
      access_token: session["access_token"],
      current_user: session["current_user"],
      permissions: session["permissions"],
      board_id: session["board_id"],
      csrf_token: session["csrf_token"],
      submit_handler: "create",
      submit_disble_message: "Creating",
      changeset: List.create_changeset(%List{})
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}

  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.ListView, "new.html", assigns)

  def handle_event("create", %{"list" => params}, socket) do
    access_token = socket.assigns.access_token
    params = Map.put(params, "access_token", access_token)

    case Lists.create_list(params) do
      {:ok, list} ->
        Phoenix.PubSub.broadcast(Frontend.PubSub, "list", {"list", "create", payload: %{list: list}})

        assign(socket, changeset: List.create_changeset(%List{}))

        {:noreply,
        socket
        |> put_flash(:info, "List created successfully.")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
