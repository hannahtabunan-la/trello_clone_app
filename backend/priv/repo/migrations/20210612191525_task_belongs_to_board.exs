defmodule Backend.Repo.Migrations.TaskBelongsToBoard do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :board_id, references(:boards)
    end
  end
end
