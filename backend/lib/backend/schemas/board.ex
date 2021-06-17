defmodule Backend.Schemas.Board do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Schemas.User
  alias Backend.Schemas.Task
  alias Backend.Schemas.Permission

  schema "boards" do
    field :name, :string
    belongs_to :user, User  # User relationship
    has_many :tasks, Task  # Task relationship
    has_many :permissions, Permission  # Task relationship

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
    |> assoc_constraint(:user)
  end
end
