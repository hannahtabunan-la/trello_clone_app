defmodule Backend.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :comment, :string
      add :is_deleted, :boolean, default: false

      timestamps()
    end
  end
end
