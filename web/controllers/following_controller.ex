defmodule App.FollowingController do
  use App.Web, :controller

  plug App.SetUser

  def index(conn, _param) do
    user = conn.assigns[:user]
    following = user.following |> Repo.preload(:user)
    render conn, "index.html", user: user, following: following
  end
end
