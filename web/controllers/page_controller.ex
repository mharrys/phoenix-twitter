defmodule App.PageController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Tweet
  alias App.User

  def index(conn, _params) do
    tweets = case get_session(conn, :current_user) do
      nil ->
        Repo.all Tweet
        |> order_by([t], [desc: t.inserted_at])
        |> preload(:user)
      current_user ->
        Repo.all Tweet
        |> order_by([t], [desc: t.inserted_at])
        |> join(:left, [t], f in Favorite, f.user_id == ^current_user.id and f.tweet_id == t.id)
        |> select([t, f], %{t | current_user_favorite_id: f.id})
    end
    users = Repo.all from t in User, order_by: [desc: t.inserted_at]
    render conn, "index.html", tweets: tweets, users: users
  end
end
