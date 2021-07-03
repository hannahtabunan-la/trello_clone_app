defmodule Frontend.Schemas.Task do

  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :id,
    :title,
    :position,
    :user_id,
    :board_id,
    :list_id,
    :is_deleted,
    :inserted_at,
    :updated_at
  ]

  # @derive {Phoenix.Param, key: :id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "tasks" do
    field :id, :id
    field :title, :string
    field :position, :decimal, default: 1.0
    field :is_deleted, :boolean, default: false
    field :user_id, :id
    field :board_id, :id
    field :list_id, :id

    timestamps()
  end

  @update_attrs [
    :title,
    :position,
    :is_deleted,
    :list_id
  ]

  def update_attrs, do: @update_attrs

  def changeset(struct, params \\ %{}) do
    cast(struct, params, @schema_fields)
  end

  def create_changeset(task, params \\ %{}) do
    task
    |> cast(params, [:title, :user_id, :board_id, :list_id])
    |> validate_required([:title, :board_id, :list_id])
  end

  def update_changeset(task, params \\ %{}, update_attrs \\ @update_attrs) do
    task
    |> cast(params, update_attrs)
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      id: :id,
      q: :string,
      limit: :integer,
      page: :integer
    }

    {struct, types}
    |> cast(params, Map.keys(types))
  end
end
