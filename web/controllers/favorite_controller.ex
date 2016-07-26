defmodule App.FavoriteController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Retweet
  alias App.Tweet

  plug App.SetUser, [:favorites] when action in [:index]
  plug App.LoginRequired when action in [:create, :delete]

  def index(conn, %{"user_id" => user_id}) do
    query = Favorite
    |> where([f], f.user_id == ^user_id)
    |> join(:left, [f], t in assoc(f, :tweet))
    query = case get_session(conn, :current_user) do
      nil ->
        query
        |> select([f, t], t)
      current_user ->
        query
        |> join(:left, [f, _], f2 in Favorite, f2.tweet_id == f.tweet_id and f2.user_id == ^current_user.id)
        |> join(:left, [t, _, _], r in Retweet, r.user_id == ^current_user.id and r.tweet_id == t.id)
        |> select([f, t, f2, r], %{t | current_user_favorite_id: f2.id, current_user_retweet_id: r.id})
    end
    tweets = Repo.all query
    render conn, "index.html", tweets: tweets
  end

  def create(conn, %{"tweet_id" => tweet_id}) do
    current_user = conn.assigns[:current_user]
    tweet = Repo.get! Tweet, tweet_id
    params = %{user_id: current_user.id, tweet_id: tweet.id}
    case Repo.insert(Favorite.changeset(%Favorite{}, params)) do
      {:ok, _favorite} ->
        redirect conn, to: user_path(conn, :show, tweet.user_id)
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to favorite tweet.")
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
    redirect conn, to: user_path(conn, :show, current_user.id)
  end
end
