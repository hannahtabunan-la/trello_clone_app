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

  def get_first_charac_string(""), do: ""

  def get_first_charac_string(nil), do: ""

  def get_first_charac_string(string) do
    String.split(string)
    |> Enum.map(&(String.first(&1)))
    |> List.to_string
    |> String.upcase
  end

  def get_current_user_email(conn), do: conn.private.plug_session["user"].email
end
