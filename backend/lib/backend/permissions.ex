defmodule Backend.Permissions do
  @moduledoc """
  The Permission context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Schemas.Permission

  @doc """
  Returns the list of permissions.

  ## Examples

      iex> list_permissions()
      [%Permission{}, ...]

  """
  def list_permissions do
    Repo.all(Permission)
  end

  @doc """
  Gets a single permission.

  Raises `Ecto.NoResultsError` if the Permission does not exist.

  ## Examples

      iex> get_permission!(123)
      %Permission{}

      iex> get_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission!(id), do: Repo.get!(Permission, id)

  @doc """
  Creates a permission.

  ## Examples

      iex> create_permission(%{field: value})
      {:ok, %Permission{}}

      iex> create_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.create_changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, permission} -> {:ok, Repo.preload(permission, [:user, :board], force: true)}
      {:error, permission} -> {:error, permission}
    end
  end

  @doc """
  Updates a permission.

  ## Examples

      iex> update_permission(permission, %{field: new_value})
      {:ok, %Permission{}}

      iex> update_permission(permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.update_changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, permission} -> {:ok, Repo.preload(permission, [:user, :board], force: true)}
      {:error, permission} -> {:error, permission}
    end
  end

  @doc """
  Deletes a permission.

  ## Examples

      iex> delete_permission(permission)
      {:ok, %Permission{}}

      iex> delete_permission(permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission changes.

  ## Examples

      iex> change_permission(permission)
      %Ecto.Changeset{data: %Permission{}}

  """
  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end

  def list_permissions_for_board(board_id) do
    query = from p in Permission,
        join: b in assoc(p, :board),
        where: p.board_id == ^board_id
    Repo.all(query)
  end
end
