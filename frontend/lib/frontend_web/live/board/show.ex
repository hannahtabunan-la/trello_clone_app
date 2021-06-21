defmodule FrontendWeb.Live.Board.Show do
  use FrontendWeb, :live_view

  alias FrontendWeb.Router.Helpers, as: Routes

  alias Frontend.Schemas.Board
  alias Frontend.API.Boards

  def mount(_params, session, socket) do
    assigns = %{
      # access_token: session.access_token,
      # current_user: session.current_user,
      board: session["board"]
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}
  end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "show_content.html", assigns)
end
