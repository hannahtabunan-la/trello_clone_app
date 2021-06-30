defmodule FrontendWeb.Live.Components.List.DropZoneComponent do

  use Phoenix.LiveComponent

  @impl true

  def mount(socket) do
    {:ok, socket}
  end

  @impl true

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.Board.ListView, "drop_zone.html", assigns)
end
