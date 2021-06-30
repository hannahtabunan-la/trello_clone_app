defmodule Frontend.Schemas.List do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :id,
    :title,
    :position,
    :is_deleted,
    :user_id,
    :board_id
  ]

  # @derive {Phoenix.Param, key: :id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "lists" do
    field :id, :id
    field :is_deleted, :boolean, default: false
    field :title, :string
    field :position, :decimal, default: 1.0
    field :board_id, :id
    field :user_id, :id

    timestamps()
  end

  # def schema_fields, do: @schema_fields

  def changeset(struct, params \\ %{}) do
    cast(struct, params, @schema_fields)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :position])
    |> validate_required([:title])
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :position])
    |> validate_required([:title])
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
