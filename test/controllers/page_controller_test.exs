defmodule App.PageControllerTest do
  use App.ConnCase

  test "GET /", %{conn: conn} do
    content = conn |> get("/") |> html_response(200)
    Enum.map(["Latest Users", "Latest Tweets"], fn item ->
      assert content =~ item
    end)
  end
end
