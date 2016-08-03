defmodule App.SignupControllerTest do
  use App.ConnCase

  test "form fields", %{conn: conn} do
    content = conn |> get("/signup") |> html_response(200)
    Enum.map(["Login", "Password", "Password confirm", "Name", "Email (Optional)"], fn item ->
      assert content =~ item
    end)
  end
end
