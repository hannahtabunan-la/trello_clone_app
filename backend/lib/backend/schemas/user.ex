defmodule Backend.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Schemas.Board
  alias Backend.Schemas.Task
  alias Backend.Schemas.Permission

  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :username, :string
    has_many :boards, Board  # Board relationship
    has_many :tasks, Task  # User relationship
    has_many :permissions, Permission  # User relationship

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :password])
    |> validate_required([:username, :name, :password])
    |> validate_format(:username, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:username)
    |> validate_length(:password, min: 6)
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        ->
          put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
          IO.puts("FAILED")
          changeset
    end
  end
end
