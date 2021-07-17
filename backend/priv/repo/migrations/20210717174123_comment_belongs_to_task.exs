defmodule Backend.Repo.Migrations.CommentBelongsToTask do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :board_id, references(:boards)
    end
  end
end
