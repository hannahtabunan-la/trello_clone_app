defmodule FrontendWeb.BoardView do
  use FrontendWeb, :view

  def permission_label_color(:manage), do: "bg-violet-500"

  def permission_label_color(:write), do: "bg-violet-300"

  def permission_label_color(:read), do: "bg-violet-100"
end
