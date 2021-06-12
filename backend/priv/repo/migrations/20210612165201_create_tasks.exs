defmodule Backend.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :is_deleted, :boolean, default: false, null: false
      # TODO: Add board relationship

      timestamps()
    end

  end
end
