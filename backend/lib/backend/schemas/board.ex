defmodule Backend.Schemas.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :name, :string
    belongs_to :user, Backend.Schemas.User  # User relationship
    has_many :tasks, Backend.Schemas.Task  # Task relationship

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
