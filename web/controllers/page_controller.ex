defmodule App.PageController do
  use App.Web, :controller

  alias App.Tweet
  alias App.User

  def index(conn, _params) do
    tweets = Repo.all from t in Tweet, order_by: [desc: t.inserted_at]
    users = Repo.all from t in User, order_by: [desc: t.inserted_at]
    render conn, "index.html", tweets: tweets, users: users
  end
end
