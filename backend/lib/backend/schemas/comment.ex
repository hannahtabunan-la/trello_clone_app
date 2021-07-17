defmodule Backend.Schemas.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @schemas [
    :comment,
    :is_deleted,
    :task_id,
    :user_id
  ]

  @required [
    :comment,
    :task_id,
    :user_id
  ]

  schema "comments" do
    field :is_deleted, :boolean, default: false
    field :comment, :string
    belongs_to :task, Backend.Schemas.Task  # Task relationship
    belongs_to :user, Backend.Schemas.User # User relationship

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @schemas)
    |> validate_required(@required)
  end

  def create_changeset(comment, attrs) do
    comment
    |> cast(attrs, @schemas)
    |> validate_required(@required)
  end

  def update_changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment, :is_deleted])
    |> validate_required(@required)
  end
end
