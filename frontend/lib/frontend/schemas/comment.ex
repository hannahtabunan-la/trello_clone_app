defmodule Frontend.Schemas.Comment do

  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :id,
    :comment,
    :task_id,
    :user_id,
    :is_deleted,
    :inserted_at,
    :updated_at,
    :created_by
  ]

  # @derive {Phoenix.Param, key: :id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "comments" do
    field :id, :id
    field :comment, :string
    field :is_deleted, :boolean, default: false
    field :task_id, :id
    field :user_id, :id
    field :created_by, :map

    timestamps()
  end

  @update_attrs [
    :comment,
    :is_deleted
  ]

  def update_attrs, do: @update_attrs

  def changeset(struct, params \\ %{}) do
    cast(struct, params, @schema_fields)
  end

  def create_changeset(comment, params \\ %{}) do
    comment
    |> cast(params, [:comment, :task_id])
    |> validate_required([:comment, :task_id])
  end

  def update_changeset(comment, params \\ %{}, update_attrs \\ @update_attrs) do
    comment
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
