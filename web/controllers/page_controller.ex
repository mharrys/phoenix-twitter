defmodule App.PageController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Retweet
  alias App.Tweet
  alias App.User

  @num_tweets 5
  @num_users  5

  def index(conn, _params) do
    tweets = case get_session(conn, :current_user) do
      nil ->
        Repo.all Tweet
        |> order_by([t], [desc: t.inserted_at])
        |> limit([t], @num_tweets)
        |> preload(:user)
      current_user ->
        Repo.all Tweet
        |> order_by([t], [desc: t.inserted_at])
        |> limit([t], @num_tweets)
        |> join(:left, [t], f in Favorite, f.user_id == ^current_user.id and f.tweet_id == t.id)
        |> join(:left, [t, f], r in Retweet, r.user_id == ^current_user.id and r.tweet_id == t.id)
        |> select([t, f, r], %{t | current_user_favorite_id: f.id, current_user_retweet_id: r.id})
    end
    tweets = tweets |> Repo.preload(:user)
    users = Repo.all from t in User, order_by: [desc: t.inserted_at], limit: @num_users
    render conn, "index.html", tweets: tweets, users: users
  end
end
