defmodule App.UserController do
  use App.Web, :controller

  def show(conn, %{"login" => login}) do
    case Repo.get_by(User, login: login) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(App.ErrorView, "404.html")
      user ->
        render conn, "index.html", user: Repo.preload(user, [:tweets])
    end
  end
end
