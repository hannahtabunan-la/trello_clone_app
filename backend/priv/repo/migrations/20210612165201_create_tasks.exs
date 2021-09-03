defmodule Backend.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :is_deleted, :boolean, default: false
      add :position, :decimal, default: 1.0

      timestamps()
    end

  end
end
