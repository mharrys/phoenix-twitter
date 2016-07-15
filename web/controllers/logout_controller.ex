defmodule App.LogoutController do
  use App.Web, :controller

  def index(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: page_path(conn, :index))
  end
end
