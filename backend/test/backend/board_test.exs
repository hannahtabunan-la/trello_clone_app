defmodule Backend.BoardTest do
  use Backend.DataCase

  alias Backend.Board

  describe "tasks" do
    alias Backend.Board.Task

    @valid_attrs %{is_deleted: true, status: "some status", title: "some title"}
    @update_attrs %{is_deleted: false, status: "some updated status", title: "some updated title"}
    @invalid_attrs %{is_deleted: nil, status: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Board.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Board.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Board.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Board.create_task(@valid_attrs)
      assert task.is_deleted == true
      assert task.status == "some status"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Board.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Board.update_task(task, @update_attrs)
      assert task.is_deleted == false
      assert task.status == "some updated status"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Board.update_task(task, @invalid_attrs)
      assert task == Board.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Board.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Board.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Board.change_task(task)
    end
  end
end
