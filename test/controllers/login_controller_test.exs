defmodule App.LoginControllerTest do
  use App.ConnCase, async: true

  @login "joe"
  @password "password"

  setup do
    conn = build_conn()
    user = %{user: %{
      login: @login,
      name: "name",
      password: @password,
      password_confirmation: @password,
      email: "email"
    }}
    post(conn, signup_path(conn, :create), user)
    {:ok, conn: conn}
  end

  test "can login with correct login and password", %{conn: conn} do
    login = p(@login, @password)
    assert post(conn, login_path(conn, :create), login).status == 302
  end

  test "can't login with incorrect login or password", %{conn: conn} do
    login1 = p(@login, "wrong")
    login2 = p("wrong", @password)
    assert post(conn, login_path(conn, :create), login1).status == 200
    assert post(conn, login_path(conn, :create), login2).status == 200
  end

  defp p(login, password) do
    %{login: %{login: login, password: password}}
  end
end
