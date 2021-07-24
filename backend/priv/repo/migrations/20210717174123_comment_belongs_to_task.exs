defmodule Backend.Repo.Migrations.CommentBelongsToTask do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :task_id, references(:tasks)
    end
  end
end
