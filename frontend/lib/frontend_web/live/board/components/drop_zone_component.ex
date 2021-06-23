defmodule FrontendWeb.Live.Components.DropZoneComponent do

  use Phoenix.LiveComponent

  @impl true

  def mount(socket) do
    {:ok, socket}
  end

  @impl true

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "drop_zone.html", assigns)
end
