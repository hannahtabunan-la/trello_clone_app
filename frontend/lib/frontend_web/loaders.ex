defmodule FrontendWeb.Loaders do
  use PolicyWonk.Load
  use PolicyWonk.Resource

  # alias FrontendWeb.ErrorHandler

  alias FrontendWeb.Loaders.PermissionLoaders

  def resource(conn, resource, params)
      when resource in [:permissions],
    do: PermissionLoaders.resource(conn, resource, params)
end
