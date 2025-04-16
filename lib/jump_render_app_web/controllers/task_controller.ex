defmodule JumpRenderAppWeb.TaskController do
  use JumpRenderAppWeb, :controller

  alias JumpRenderApp.Tasks

  def export(conn, _params) do
    tasks = Tasks.list_tasks(:asc)

    csv_data =
      tasks
      |> Enum.map(fn t -> [t.title, t.due_date, t.completed] end)
      |> CSV.encode()
      |> Enum.join("")

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"tasks.csv\"")
    |> send_resp(200, csv_data)
  end
end
