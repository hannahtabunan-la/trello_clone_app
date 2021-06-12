defmodule Backend.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :name, :string
      # TODO: add user creator

      timestamps()
    end

  end
end
