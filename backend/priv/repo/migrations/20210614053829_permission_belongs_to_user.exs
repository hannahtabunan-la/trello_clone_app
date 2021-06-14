defmodule Backend.Repo.Migrations.PermissionBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:permissions) do
      add :user_id, references(:users)
    end
  end
end
