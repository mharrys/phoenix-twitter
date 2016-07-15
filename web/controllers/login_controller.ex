defmodule App.LoginController do
  use App.Web, :controller

  import App.Authenticator

  plug :redirect_authenticated

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, %{"login" => login_params}) do
    login = login_params["login"]
    password = login_params["password"]
    case authenticate(login, password) do
      nil ->
        conn
        |> put_flash(:error, "Wrong login or password.")
        |> render("index.html")
      {:ok, user} ->
        conn
        |> put_session(:id, user.id)
        |> put_flash(:info, "Successfully logged in.")
        |> redirect(to: user_tweet_path(conn, :index, user.id))
    end
  end

  defp authenticate(login, password) do
    case Repo.get_by(User, login: login) do
      nil  -> nil
      user ->
        if User.validate_password(password, user.password_hash) do
          {:ok, user}
        end
    end
  end
end
