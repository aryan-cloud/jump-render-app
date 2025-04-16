defmodule JumpRenderAppWeb.TaskLive.Index do
  use JumpRenderAppWeb, :live_view

  alias JumpRenderApp.Tasks
  alias JumpRenderApp.Tasks.Task

  @impl true
  def mount(_params, _session, socket) do
    # Prepare an empty changeset for task creation and load sorted tasks (default asc)
    changeset = Tasks.change_task(%Task{})
    tasks = Tasks.list_tasks(:asc)
    {:ok, assign(socket, tasks: tasks, sort_order: :asc, changeset: changeset)}
  end

  @impl true
  def handle_event("toggle_sort", _params, socket) do
    new_order = if socket.assigns.sort_order == :asc, do: :desc, else: :asc
    tasks = Tasks.list_tasks(new_order)
    {:noreply, assign(socket, tasks: tasks, sort_order: new_order)}
  end

  @impl true
  def handle_event("add_task", %{"task" => task_params}, socket) do
    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        changeset = Tasks.change_task(%Task{})
        tasks = Tasks.list_tasks(socket.assigns.sort_order)
        {:noreply, assign(socket, tasks: tasks, changeset: changeset)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("delete_task", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)
    tasks = Tasks.list_tasks(socket.assigns.sort_order)
    {:noreply, assign(socket, tasks: tasks)}
  end

  @impl true
  def handle_event("complete_task", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    # Mark the task as completed. Adjust the field type if needed.
    {:ok, _} = Tasks.update_task(task, %{"completed" => true})
    tasks = Tasks.list_tasks(socket.assigns.sort_order)
    {:noreply, assign(socket, tasks: tasks)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">Task List</h1>

      <!-- New Task Form -->
      <form phx-submit="add_task" class="mb-4">
        <div class="flex flex-col md:flex-row gap-4">
          <input type="text" name="task[title]" placeholder="Task Title" class="flex-1 border px-2 py-1" required/>
          <input type="date" name="task[due_date]" class="border px-2 py-1" required/>
          <button type="submit" class="bg-blue-500 text-white px-4 py-1 rounded">Add Task</button>
        </div>
      </form>

      <!-- Toggle Sort Order Button -->
      <button phx-click="toggle_sort" class="bg-blue-500 text-white px-4 py-2 rounded mb-4">
        Sort by Due Date (<%= @sort_order %>)
      </button>

      <!-- Task Table -->
      <table class="table-auto w-full border-collapse border border-gray-300">
        <thead>
          <tr>
            <th class="border px-4 py-2">Title</th>
            <th class="border px-4 py-2">Due Date</th>
            <th class="border px-4 py-2">Completed</th>
            <th class="border px-4 py-2">Actions</th>
          </tr>
        </thead>
        <tbody>
          <%= for task <- @tasks do %>
            <tr>
              <td class="border px-4 py-2"><%= task.title %></td>
              <td class="border px-4 py-2"><%= task.due_date %></td>
              <td class="border px-4 py-2"><%= if task.completed, do: "Yes", else: "No" %></td>
              <td class="border px-4 py-2 space-x-2">
                <%= if !task.completed do %>
                  <button phx-click="complete_task" phx-value-id={task.id} class="bg-green-500 text-white px-2 py-1 rounded">
                    Complete
                  </button>
                <% end %>
                <button phx-click="delete_task" phx-value-id={task.id} class="bg-red-500 text-white px-2 py-1 rounded">
                  Delete
                </button>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>

      <!-- CSV Download Button -->
      <a href={~p"/tasks/export"} class="bg-yellow-500 text-white px-4 py-2 rounded mt-4 inline-block">
        Download CSV
      </a>
    </div>
    """
  end
end

defmodule JumpRenderApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      JumpRenderApp.Repo,
      # Start the Telemetry supervisor
      JumpRenderAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: JumpRenderApp.PubSub},
      # Start the Endpoint (http/https)
      JumpRenderAppWeb.Endpoint
      # Start a worker by calling: JumpRenderApp.Worker.start_link(arg)
      # {JumpRenderApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html for other strategies and supported options
    opts = [strategy: :one_for_one, name: JumpRenderApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JumpRenderAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end


