defmodule Backend.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Schemas.Task
  alias Backend.Tasks

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    query = from t in Task,
      join: u in assoc(t, :user),
      join: a in assoc(t, :assignee),
      preload: [user: u, assignee: a]
    Repo.all(query)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.create_changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, task} -> {:ok, Repo.preload(task, [:board, :user], force: true)}
      {:error, task} -> {:error, task}
    end
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.update_changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, task} -> {:ok, Repo.preload(task, [:board, :user], force: true)}
      {:error, task} -> {:error, task}
    end
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def list_tasks_not_deleted(board_id) do
    query = from t in Task,
      preload: [:user, :list, :assignee],
      where: t.is_deleted == :false and
             t.board_id == ^board_id
    Repo.all(query)
  end


  @doc """
  Returns the last position from the table.
  """
  def get_last_position() do
    query = from t in Task,
      select: [:position],
      order_by: [desc: t.position], limit: 1
    Repo.one(query)
  end

  def handle_changeset_error({:error, task}) do

  end
end
