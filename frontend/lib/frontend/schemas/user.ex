defmodule Frontend.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :user_id,
    :name,
    :password,
    :encrypted_password,
    :email
  ]

  @derive {Phoenix.Param, key: :user_id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "users" do
    field :user_id, Ecto.UUID, primary_key: true
    field :name, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> put_hashed_password
  end

  def signin_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        ->
          put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
          changeset
    end
  end
end
