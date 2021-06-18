defmodule BackendWeb.AccountView do
  use BackendWeb, :view
  alias BackendWeb.AccountView

  def render("account.json", %{user: user, token: token}) do
    %{user: %{
      id: user.id,
      email: user.email,
      name: user.name,
      inserted_at: NaiveDateTime.to_string(user.inserted_at),
      updated_at: NaiveDateTime.to_string(user.updated_at)
    }, token: token}
  end
end
