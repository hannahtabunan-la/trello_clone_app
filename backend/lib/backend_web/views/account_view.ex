defmodule BackendWeb.AccountView do
  use BackendWeb, :view
  alias BackendWeb.AccountView

  def render("account.json", %{user: user, token: token}) do
    %{id: user.id,
      username: user.username,
      name: user.name,
      token: token,
      inserted_at: NaiveDateTime.to_string(user.inserted_at),
      updated_at: NaiveDateTime.to_string(user.updated_at)}
  end
end
