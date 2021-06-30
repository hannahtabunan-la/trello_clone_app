defmodule FrontendWeb.Live.Board.Index do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes
  alias Frontend.API.Boards

  def mount(_params, session, socket) do
    assigns = %{
      access_token: session["access_token"],
      # current_user: session.current_user,
      boards: session["boards"],
      board_id: nil,
      csrf_token: session["csrf_token"],
      view: :list,
      modal: nil
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Frontend.PubSub, "board")
    end

    {:ok, assign(socket, assigns)}
  end

  # defp fetch(socket) do
  #   assign(socket, boards: Tasks.list_task(), page_title: "To Do App")
  # end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "index_content.html", assigns)

  def handle_event("new_board", _params, socket) do
    {:noreply, assign(socket, modal: :new)}
  end

  def handle_event("edit_board", %{"board" => board_id}, socket) do
    assign = %{
      modal: :edit,
      board_id: board_id
    }

    {:noreply, assign(socket, assign)}
  end

  def handle_info({_event, "close_modal", _data}, socket) do
    {:noreply, assign(socket, modal: nil)}
  end
end
