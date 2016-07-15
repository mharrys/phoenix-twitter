defmodule App.LoginController do
  use App.Web, :controller

  import App.Authenticator, only: [authenticate: 2, redirect_authenticated: 2]

  plug :redirect_authenticated

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, %{"login" => params}) do
    case authenticate(params["login"], params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:id, user.id)
        |> put_flash(:info, "Successfully logged in.")
        |> redirect(to: user_tweet_path(conn, :index, user.id))
      :error ->
        conn
        |> put_flash(:error, "Wrong login or password.")
        |> render("index.html")
    end
  end
end
