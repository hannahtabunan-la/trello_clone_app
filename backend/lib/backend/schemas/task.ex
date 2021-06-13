defmodule Backend.Schemas.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :is_deleted, :boolean, default: false
    field :status, Ecto.Enum, values: [:pending, :in_progress, :completed], default: :pending
    field :title, :string
    field :position, :decimal, default: 1.0
    belongs_to :board, Backend.Schemas.Board  # Board relationship
    belongs_to :user, Backend.Schemas.User  # User relationship

    timestamps()
  end

  @doc false
  def create_changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :status, :is_deleted, :user_id, :board_id])
    |> validate_required([:title, :board_id])
    |> validate_inclusion(:status, [:pending, :in_progress, :completed])
    |> assoc_constraint(:board)
  end

  def update_changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :status, :is_deleted])
    |> validate_required([:title])
    |> validate_inclusion(:status, [:pending, :in_progress, :completed])
  end
end
