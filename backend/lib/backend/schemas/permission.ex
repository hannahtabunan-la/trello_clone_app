defmodule Backend.Schemas.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Schemas.User
  alias Backend.Schemas.Board

  schema "permissions" do
    field :type, Ecto.Enum, values: [:read, :write, :manage], default: :read
    timestamps()
    belongs_to :user, User  # User relationship
    belongs_to :board, Board  # Board relationship
  end

  @doc false
  def create_changeset(permission, attrs) do
    permission
    |> cast(attrs, [:type, :user_id, :board_id])
    |> validate_required([:type, :user_id, :board_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:board)
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
