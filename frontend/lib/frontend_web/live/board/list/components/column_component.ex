defmodule FrontendWeb.Live.Components.List.ColumnComponent do

  use Phoenix.LiveComponent

  @impl true

  def mount(socket) do
    {:ok, socket}
  end

  @impl true

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.ListView, "columns.html", assigns)
end
