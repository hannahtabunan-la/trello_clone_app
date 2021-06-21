defmodule FrontendWeb.Live.Board.Index do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes
  alias Frontend.API.Boards

  def mount(_params, session, socket) do
    assigns = %{
      # access_token: session.access_token,
      # current_user: session.current_user,
      boards: session["boards"],
      changeset: :changeset,
      view: :list
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}
  end

  # defp fetch(socket) do
  #   assign(socket, boards: Tasks.list_task(), page_title: "To Do App")
  # end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "index_content.html", assigns)
end
