defmodule Backend.Schemas.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :is_deleted, :boolean, default: false
    field :status, Ecto.Enum, values: [:pending, :in_progress, :completed]
    field :title, :string
    # TODO: Add board relationship

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :status, :is_deleted])
    |> validate_required([:title, :status, :is_deleted])
  end
end
