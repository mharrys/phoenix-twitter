defmodule App.LayoutViewTest do
  use App.ConnCase, async: true

  test "menu options when not signed in", %{conn: conn} do
    content = conn
    |> get("/")
    |> html_response(200)
    Enum.map(["Users", "Tweets", "Signup", "Login"], fn item ->
      assert content =~ item
    end)
  end
end
