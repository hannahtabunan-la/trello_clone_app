defmodule FrontendWeb.Plugs.AuthenticatedPipeline do
  import Plug.Conn
  use FrontendWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :access_token) do
      nil ->
        conn
        |> redirect(to: "/signin")
        |> halt()

      access_token ->
        current_user = get_session(conn, :user)

        conn
        |> assign(:access_token, access_token)
        |> assign(:current_user, current_user)
        |> put_req_header("authorization", "Bearer #{access_token}")
    end
  end
end
