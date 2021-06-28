defmodule Frontend.Schemas.Board do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :id,
    :name,
    :user_id,
    :inserted_at,
    :updated_at
  ]

  # @derive {Phoenix.Param, key: :id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key false
  schema "boards" do
    field :id, :id
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  # def schema_fields, do: @schema_fields

  def changeset(struct, params \\ %{}) do
    cast(struct, params, @schema_fields)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
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
