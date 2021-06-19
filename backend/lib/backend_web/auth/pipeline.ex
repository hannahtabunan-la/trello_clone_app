defmodule BackendWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :backend,
    module: BackendWeb.Auth.Guardian,
    error_handler: BackendWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
