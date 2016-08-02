defmodule App.FavoriteController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Retweet
  alias App.Tweet

  plug App.SetUser when action in [:index]
  plug App.LoginRequired when action in [:create, :delete]

  def index(conn, %{"user_id" => user_id}) do
    user = conn.assigns[:user]
    query = Favorite
    |> order_by([f], [desc: f.inserted_at])
    |> where([f], f.user_id == ^user_id)
    |> join(:left, [f], t in assoc(f, :tweet))
    query = case get_session conn, :current_user do
      nil ->
        query
        |> select([f, t], t)
      current_user ->
        query
        |> join(:left, [f, _], f2 in Favorite, f2.tweet_id == f.tweet_id and f2.user_id == ^current_user.id)
        |> join(:left, [t, _, _], r in Retweet, r.user_id == ^current_user.id and r.tweet_id == t.id)
        |> select([f, t, f2, r], %{t | current_user_favorite_id: f2.id, current_user_retweet_id: r.id})
    end
    tweets = Repo.all(query) |> Repo.preload(:user)
    render conn, "index.html", user: user, tweets: tweets
  end

  def create(conn, %{"tweet_id" => tweet_id}) do
    current_user = conn.assigns[:current_user]
    tweet = Repo.get! Tweet, tweet_id
    params = %{user_id: current_user.id, tweet_id: tweet.id}
    case Repo.insert Favorite.changeset(%Favorite{}, params) do
      {:ok, _favorite} ->
        conn
        |> put_flash(:info, "Tweet added to your favorites")
        |> redirect(to: user_favorite_path(conn, :index, current_user.id))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to favorite tweet")
        |> redirect(to: user_path(conn, :show, tweet.user_id))
        |> halt
    end
  end

  def delete(conn, %{"tweet_id" => tweet_id}) do
    current_user = conn.assigns[:current_user]
    query = from f in Favorite,
            where: f.tweet_id == ^tweet_id and f.user_id == ^current_user.id
    favorite = Repo.one! query
    Repo.delete! favorite
    conn
    |> put_flash(:info, "Tweet removed from your favorites")
    |> redirect(to: user_favorite_path(conn, :index, current_user.id))
  end
end
