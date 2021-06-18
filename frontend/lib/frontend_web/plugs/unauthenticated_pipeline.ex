defmodule FrontendWeb.Plugs.UnauthenticatedPipeline do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :access_token) do
      nil ->
        conn

      _access_token ->
        delete_session(conn, :access_token)
    end
  end
end
