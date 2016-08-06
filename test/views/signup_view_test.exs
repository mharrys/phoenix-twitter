defmodule App.SignupViewTest do
  use App.ConnCase, async: true

  test "has expected form fields", %{conn: conn} do
    content = conn |> get(signup_path(conn, :index)) |> html_response(200)
    Enum.map(["Login", "Password", "Password confirm", "Name", "Email (Optional)"], fn item ->
      assert content =~ item
    end)
  end
end
