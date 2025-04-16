defmodule JumpRenderApp.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :due_date, :date
    field :completed, :boolean, default: false

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :due_date, :completed])
    |> validate_required([:title, :due_date])
  end
end
