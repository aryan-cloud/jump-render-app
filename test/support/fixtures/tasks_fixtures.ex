defmodule JumpRenderApp.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JumpRenderApp.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        due_date: ~D[2025-04-15],
        title: "some title"
      })
      |> JumpRenderApp.Tasks.create_task()

    task
  end
end
