defmodule BackendWeb.Auth.Guardian do
  use Guardian, otp_app: :backend

  alias Backend.Models.Users

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok,  resource}
  end

  def authenticate(username, password) do
    with {:ok, user} <- Users.get_by_username(username) do
      case validate_password(password, user.encrypted_password) do
        true ->
          create_token(user)
        false ->
          {:error, :unauthorized}
      end
    end
  end

  def validate_password(password, encrypted_password) do
    Comeonin.Bcrypt.checkpw(password, encrypted_password)
  end

  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
