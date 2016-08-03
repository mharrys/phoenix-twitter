defmodule App.ErrorViewTest do
  use App.ConnCase, async: true

  import Phoenix.View

  test "renders 401.html" do
    content = render_to_string App.ErrorView, "401.html", []
    assert content =~ "401"
  end

  test "renders 404.html" do
    content = render_to_string App.ErrorView, "404.html", []
    assert content =~ "404"
  end

  test "render 500.html" do
    content = render_to_string App.ErrorView, "500.html", []
    assert content =~ "500"
  end

  test "render any other" do
    content = render_to_string App.ErrorView, "505.html", []
    assert content =~ "500"
  end
end
