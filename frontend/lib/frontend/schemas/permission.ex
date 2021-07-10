defmodule Frontend.Schemas.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :id,
    :type,
    :user_id,
    :board_id
  ]

  @types [
    :read, :write, :manage
  ]

  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "boards" do
    field :id, :id
    field :user_id, :id
    field :board_id, :id
    field :type, Ecto.Enum, values: @types, default: :read

    timestamps()
  end

  # def schema_fields, do: @schema_fields

  def changeset(struct, params \\ %{}) do
    cast(struct, params, @schema_fields)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :user_id, :board_id])
    |> validate_required([:name, :user_id, :board_id])
    |> validate_inclusion(:type, @types)
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type])
    |> validate_required([:type])
    |> validate_inclusion(:type, @types)
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
