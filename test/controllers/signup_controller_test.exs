defmodule App.SignupControllerTest do
  use App.ConnCase, async: true

  alias App.Repo
  alias App.User

  test "can signup", %{conn: conn} do
    user = %{user: %{
      login: "login",
      name: "name",
      password: "password",
      password_confirmation: "password",
      email: "email"
    }}
    conn = post(conn, signup_path(conn, :create), user)
    assert conn.status == 302  # redirected to profile
    assert length(Repo.all from u in User, where: u.login == ^user.user.login) == 1
  end
end
