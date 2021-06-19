defmodule Frontend.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :id,
    :name,
    :email,
    :inserted_at,
    :updated_at
  ]

  # @derive {Phoenix.Param, key: :user_id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "users" do
    field :user_id, :id
    field :name, :string
    field :password, :string, virtual: true
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    cast(struct, params, @schema_fields)
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
  end

  def signin_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
