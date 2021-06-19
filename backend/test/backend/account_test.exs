defmodule Backend.AccountTest do
  use Backend.DataCase

  alias Backend.Account

  describe "users" do
    alias Backend.Account.User

    @valid_attrs %{name: "some name", password: "some password", username: "some username"}
    @update_attrs %{name: "some updated name", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{name: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.name == "some name"
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.name == "some updated name"
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "permissions" do
    alias Backend.Account.Permission

    @valid_attrs %{type: "some type"}
    @update_attrs %{type: "some updated type"}
    @invalid_attrs %{type: nil}

    def permission_fixture(attrs \\ %{}) do
      {:ok, permission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_permission()

      permission
    end

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Account.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Account.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      assert {:ok, %Permission{} = permission} = Account.create_permission(@valid_attrs)
      assert permission.type == "some type"
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{} = permission} = Account.update_permission(permission, @update_attrs)
      assert permission.type == "some updated type"
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_permission(permission, @invalid_attrs)
      assert permission == Account.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Account.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Account.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Account.change_permission(permission)
    end
  end
end
