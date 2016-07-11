defmodule App.SignupControllerTest do
  use App.ConnCase

  test "form fields", %{conn: conn} do
    conn = get conn, "/signup"
    response = html_response(conn, 200)
    assert response =~ "Login"
    assert response =~ "Password"
    assert response =~ "Name"
    assert response =~ "Email (Optional)"
  end
end
