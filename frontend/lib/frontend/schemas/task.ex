defmodule Frontend.Schemas.Task do

  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :id,
    :title,
    :status,
    :position,
    :user_id,
    :board_id,
    :is_deleted,
    :inserted_at,
    :updated_at
  ]

  # @derive {Phoenix.Param, key: :id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "boards" do
    field :id, :id
    field :title, :string
    field :status, Ecto.Enum, values: [:pending, :in_progress, :completed], default: :pending
    field :position, :decimal, default: 1.0
    field :is_deleted, :boolean, default: false
    field :user_id, :id
    field :board_id, :id

    timestamps()
  end

  @update_attrs [
    :title,
    :status,
    :position,
    :is_deleted
  ]

  def update_attrs, do: @update_attrs

  def changeset(struct, params \\ %{}) do
    cast(struct, params, @schema_fields)
  end

  def create_changeset(task, params \\ %{}) do
    task
    |> cast(params, [:title, :status, :is_deleted, :user_id, :board_id])
    |> validate_required([:title, :board_id])
    |> validate_inclusion(:status, [:pending, :in_progress, :completed])
  end

  def update_changeset(task, params \\ %{}, update_attrs \\ @update_attrs) do
    task
    |> cast(params, update_attrs)
    |> validate_inclusion(:status, [:pending, :in_progress, :completed])
  end
end
