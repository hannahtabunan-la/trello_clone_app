defmodule FrontendWeb.Live.Components.CardsComponent do
  use Phoenix.LiveComponent

  @impl true

  def mount(socket) do
    {:ok, socket}
  end

  @impl true

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.ComponentView, "cards.html", assigns)
end
