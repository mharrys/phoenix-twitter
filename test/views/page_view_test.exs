defmodule App.PageViewTest do
  use App.ConnCase, async: true

  test "if displaying latest users and tweets", %{conn: conn} do
    content = conn |> get(page_path(conn, :index)) |> html_response(200)
    Enum.map(["Latest Users", "Latest Tweets"], fn item ->
      assert content =~ item
    end)
  end
end
