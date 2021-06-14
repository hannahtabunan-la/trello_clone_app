defmodule Backend.Repo.Migrations.PermissionBelongsToBoard do
  use Ecto.Migration

  def change do
    alter table(:permissions) do
      add :board_id, references(:boards)
    end
  end
end
