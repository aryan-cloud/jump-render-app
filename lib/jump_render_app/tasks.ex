defmodule JumpRenderApp.Tasks do
  import Ecto.Query, warn: false
  alias JumpRenderApp.Repo

  alias JumpRenderApp.Tasks.Task

  def list_tasks(order \\ :asc) do
    Repo.all(from t in Task, order_by: [{^order, t.due_date}])
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task), do: Repo.delete(task)

  def change_task(%Task{} = task), do: Task.changeset(task, %{})
end
