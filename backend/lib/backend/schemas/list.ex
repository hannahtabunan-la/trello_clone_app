defmodule Backend.Schemas.List do
  use Ecto.Schema
  import Ecto.Changeset

  @schemas [
    :title,
    :position,
    :is_deleted,
    :user_id,
    :board_id
  ]

  @required [
    :title,
    :board_id
  ]

  schema "lists" do
    field :is_deleted, :boolean, default: false
    field :title, :string
    field :position, :decimal, default: 1.0
    belongs_to :board, Backend.Schemas.Board  # Board relationship
    belongs_to :user, Backend.Schemas.User # User relationship

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, @schemas)
    |> validate_required(@required)
  end

  def create_changeset(list, attrs) do
    list
    |> cast(attrs, @schemas)
    |> validate_required(@required)
  end

  def update_changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :position, :is_deleted])
    |> validate_required(@required)
  end
end
