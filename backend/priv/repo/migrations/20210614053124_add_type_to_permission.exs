defmodule Backend.Repo.Migrations.AddTypeToPermission do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE permission_type AS ENUM ('read', 'write', 'manage')"
    drop_query = "DROP TYPE permission_type"
    execute(create_query, drop_query)

    alter table(:permissions) do
      add :type, :permission_type
    end
  end
end
