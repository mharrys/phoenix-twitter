defmodule App.UserController do
  use App.Web, :controller

  def index(conn, _params) do
    users = Repo.all User
    render conn, "index.html", users: users
  end
end
