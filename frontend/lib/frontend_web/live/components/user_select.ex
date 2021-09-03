defmodule FrontendWeb.Live.Components.UserSelectComponent do
  use Phoenix.LiveComponent

  @impl true

  def mount(socket) do
    {:ok, socket}
  end

  @impl true

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.ComponentView, "user_select.html", assigns)
end
