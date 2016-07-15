defmodule App.UserController do
  use App.Web, :controller

  import Plug.Conn

  plug :set_user

  def show(conn, _params) do
    user = conn.assigns[:user]
    render conn, "index.html", user: user
  end

  defp set_user(%Plug.Conn{params: %{"login" => login}} = conn, _default) do
    case Repo.get_by(User, login: login) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(App.ErrorView, "404.html")
      user ->
        assign conn, :user, user |> Repo.preload([:tweets])
    end
  end
end
