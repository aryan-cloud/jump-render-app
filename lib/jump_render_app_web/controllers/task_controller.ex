defmodule JumpRenderAppWeb.TaskController do
  use JumpRenderAppWeb, :controller

  alias JumpRenderApp.Tasks

  def export(conn, _params) do
    tasks = Tasks.list_tasks(:asc)

    csv_content =
      [["ID", "Title", "Completed", "Due Date"] | Enum.map(tasks, &task_to_csv_row/1)]
      |> CSV.encode()
      |> Enum.join("\n")

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"tasks.csv\"")
    |> send_resp(200, csv_content)
  end

  defp task_to_csv_row(task) do
    [
      task.id,
      task.title,
      if(task.completed, do: "Yes", else: "No"),
      task.due_date
    ]
  end
end