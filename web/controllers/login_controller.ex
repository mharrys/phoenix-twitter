defmodule App.LoginController do
  use App.Web, :controller

  alias App.User

  plug App.RedirectAuthenticated

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, %{"login" => params}) do
    case authenticate(params["login"], params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, %{id: user.id, login: user.login, name: user.name})
        |> put_flash(:info, "Successfully logged in.")
        |> redirect(to: user_tweet_path(conn, :index, user))
      :error ->
        conn
        |> put_flash(:error, "Wrong login or password.")
        |> render("index.html")
    end
  end

  defp authenticate(login, password) do
    case Repo.get_by(User, login: login) do
      nil  ->
        :error
      user ->
        if User.validate_password(password, user.password_hash) do
          {:ok, user}
        else
          :error
        end
    end
  end
end
