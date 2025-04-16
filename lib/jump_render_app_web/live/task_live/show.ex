defmodule JumpRenderAppWeb.TaskLive.Show do
  use JumpRenderAppWeb, :live_view

  alias JumpRenderApp.Tasks

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    task = Tasks.get_task!(id)
    {:ok, assign(socket, task: task)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">Task Details</h1>
      <div>
        <p><strong>Title:</strong> <%= @task.title %></p>
        <p><strong>Due Date:</strong> <%= @task.due_date %></p>
        <p><strong>Completed:</strong> <%= if @task.completed, do: "Yes", else: "No" %></p>
      </div>
    </div>
    """
  end
end
