defmodule App.LoginController do
  use App.Web, :controller

  alias App.User

  plug App.RedirectAuthenticated when action in [:index, :create]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"login" => login}) do
    case Repo.get_by User, login: login do
      nil  ->
        conn
        |> put_status(:not_found)
        |> render(App.ErrorView, "404.html")
        |> halt
      user ->
        redirect conn, to: user_path(conn, :show, user.id)
    end
  end

  def create(conn, %{"login" => login_params}) do
    case authenticate login_params["login"], login_params["password"] do
      {:ok, user} ->
        conn
        |> put_session(:current_user, %{id: user.id, login: user.login, name: user.name})
        |> put_flash(:info, gettext "Successfully logged in.")
        |> redirect(to: user_path(conn, :show, user))
      :error ->
        conn
        |> put_flash(:error, gettext "Unknown login or wrong password")
        |> render("index.html")
    end
  end

  defp authenticate(login, password) do
    case Repo.get_by User, login: login do
      nil  ->
        :error
      user ->
        if User.validate_password password, user.password_hash do
          {:ok, user}
        else
          :error
        end
    end
  end
end
