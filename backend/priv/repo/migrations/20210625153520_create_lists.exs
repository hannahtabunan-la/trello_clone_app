defmodule Backend.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :is_deleted, :boolean, default: false
      add :position, :decimal, default: 1.0

      timestamps()
    end

  end
end
