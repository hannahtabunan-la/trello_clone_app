defmodule Backend.Schemas.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :is_deleted, :boolean, default: false
    field :title, :string
    field :position, :decimal, default: 1.0
    field :description, :string
    belongs_to :board, Backend.Schemas.Board  # Board relationship
    belongs_to :user, Backend.Schemas.User  # User relationship
    belongs_to :list, Backend.Schemas.List  # List relationship
    belongs_to :assignee, Backend.Schemas.User   # List relationship
    has_many :comments, Backend.Schemas.Comment  # Comment relationship

    timestamps()
  end

  @doc false
  def create_changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :is_deleted, :user_id, :board_id, :list_id])
    |> validate_required([:title, :board_id])
    |> assoc_constraint(:board)
  end

  def update_changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :is_deleted, :list_id, :assignee_id])
    |> validate_required([:title])
    |> assoc_constraint(:list)
  end

  # def validate_assignee(task, attrs) do

  # end
end
