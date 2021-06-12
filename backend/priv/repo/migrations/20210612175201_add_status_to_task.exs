defmodule Backend.Repo.Migrations.AddStatusToTask do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE task_status AS ENUM ('pending', 'in_progress', 'completed')"
    drop_query = "DROP TYPE task_status"
    execute(create_query, drop_query)

    alter table(:tasks) do
      add :status, :task_status
    end
  end
end
