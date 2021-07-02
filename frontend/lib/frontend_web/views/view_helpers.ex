defmodule FrontendWeb.ViewHelpers do
  use Phoenix.HTML

  def list_key_value(key, list) do
    case Map.has_key?(list, key) do
      true ->
        %{ ^key => value } = list
        value
      false -> []
    end
  end
end
