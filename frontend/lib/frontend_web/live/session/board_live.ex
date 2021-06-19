defmodule FrontendWeb.Live.BoardLive do
  use FrontendWeb, :live_view

  def mount(_params, session, socket) do
    assigns = %{
      # access_token: session.access_token,
      # current_user: session.current_user,
      boards: session["boards"],
      changeset: :changeset,
      view: :list
    }

    # if connected?(socket) do
    #   send(self(), :load)
    # end

    {:ok, assign(socket, assigns)}
  end

  # defp fetch(socket) do
  #   assign(socket, boards: Tasks.list_task(), page_title: "To Do App")
  # end

  def render(assigns),
    do: Phoenix.View.render(FrontendWeb.BoardView, "index_content.html", assigns)


  def handle_event("toggle_list", _params, socket) do
    {:noreply, assign(socket, :view, :new)}
  end

  def handle_event("toggle_new", _params, socket) do
    {:noreply, assign(socket, :view, :list)}
  end

  # defp fetch(socket) do
  #     tasks = Tasks.list_tasks()
  #     page_title = "Todo App"
  #     test = "hannah"
  #     # send to self
  #     assign(socket, tasks: tasks, page_title: page_title, test: test)
  # end

  # def handle_event("create", %{"task" => task}, socket) do
  #     new_position = case Tasks.last_position() do
  #         nil ->
  #             "1.0";
  #         %{ position: last_position } ->
  #             Decimal.add(last_position, "1.0")
  #     end

  #     case Tasks.create_task(Map.put(task, "position", new_position)) do
  #         {:ok, _task} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:info, "Task is successfully created.")}
  #         {:error, _task} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:error, "Failed to create task.")}
  #     end
  # end

  # def handle_event("toggle_done", %{"id" => id}, socket) do
  #     task = Tasks.get_task!(id)
  #     case Tasks.update_task(task, %{done: !task.done}) do
  #         {:ok, _task} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:info, "Task is successfully updated.")}
  #         {:error, _task} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:error, "Failed to update task.")}
  #     end
  # end

  # def handle_event("delete", %{"id" => id}, socket) do
  #     task = Tasks.get_task!(id)
  #     case Tasks.delete_task(task) do
  #         {:ok, _task} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:info, "Task is successfully deleted.")}
  #         {:error, _task} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:error, "Failed to delete task.")}
  #     end
  # end

  # def handle_info({Tasks, [:task | _], _}, socket) do
  #     {:noreply, fetch(socket)}
  # end

  # def handle_event("reorder", %{"id" => id, "position" => position}, socket) do
  #     task = Tasks.get_task!(id)

  #     case Tasks.update_task(task, %{ position: position }) do
  #         {:ok, _updated_task} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:info, "Task is reordered.")}
  #         {:error, changeset} ->
  #             {:noreply,
  #             socket
  #             |> put_flash(:error, "Failed to reorder task.")}
  #     end
  # end
end
