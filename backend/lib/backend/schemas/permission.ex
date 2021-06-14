defmodule Backend.Schemas.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :status, Ecto.Enum, values: [:read, :write, :manage], default: :read
    timestamps()
    belongs_to :board, Backend.Schemas.Board  # Board relationship
    belongs_to :user, Backend.Schemas.User  # User relationship
  end

  @doc false
  def create_changeset(permission, attrs) do
    permission
    |> cast(attrs, [:type, :user_id, :board_id])
    |> validate_required([:type, :user_id, :board_id])
    |> assoc_constraint(:user, :board)
    |> validate_inclusion(:type, [:read, :write, :manage])
  end

  @doc false
  def update_changeset(permission, attrs) do
    permission
    |> cast(attrs, [:type])
    |> validate_required([:type])
    |> validate_inclusion(:type, [:read, :write, :manage])
  end
end
