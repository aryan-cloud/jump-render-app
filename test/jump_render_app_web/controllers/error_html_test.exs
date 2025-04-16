defmodule JumpRenderAppWeb.ErrorHTMLTest do
  use JumpRenderAppWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(JumpRenderAppWeb.ErrorHTML, "404", "html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(JumpRenderAppWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
