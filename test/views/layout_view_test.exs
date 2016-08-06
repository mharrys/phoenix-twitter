defmodule App.LayoutViewTest do
  use App.ConnCase, async: true

  @current_user %{id: 1, login: "login", name: "name"}

  test "menu options when not signed in", %{conn: conn} do
    content = conn
    |> get("/")
    |> html_response(200)
    Enum.map(["Users", "Tweets", "Signup", "Login"], fn item ->
      assert content =~ item
    end)
  end

  test "menu options when signed in", %{conn: conn} do
    content = conn
    |> assign(:current_user, @current_user)
    |> get("/")
    |> html_response(200)
    Enum.map(["Users", "Tweets", "Profile", "Logout"], fn item ->
      assert content =~ item
    end)
  end
end
