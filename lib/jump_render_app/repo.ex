defmodule JumpRenderApp.Repo do
  use Ecto.Repo,
    otp_app: :jump_render_app,
    adapter: Ecto.Adapters.Postgres
end
