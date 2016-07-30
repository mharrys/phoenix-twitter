defmodule App.TweetController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Retweet
  alias App.Tweet

  def index(conn, _param) do
    tweets = case get_session(conn, :current_user) do
      nil ->
        Repo.all Tweet
        |> order_by([t], [desc: t.inserted_at])
      current_user ->
        Repo.all Tweet
        |> order_by([t], [desc: t.inserted_at])
        |> join(:left, [t], f in Favorite, f.user_id == ^current_user.id and f.tweet_id == t.id)
        |> join(:left, [t, f], r in Retweet, r.user_id == ^current_user.id and r.tweet_id == t.id)
        |> select([t, f, r], %{t | current_user_favorite_id: f.id, current_user_retweet_id: r.id})
    end
    tweets = tweets |> Repo.preload(:user)
    render conn, "index.html", tweets: tweets
  end

  plug App.SetUser when action in [:create, :delete]
  plug App.LoginRequired when action in [:create]
  plug :is_authorized? when action in [:create]

  def create(conn, %{"tweet" => tweet_params}) do
    user = conn.assigns[:user]
    changeset = Tweet.changeset(%Tweet{user_id: user.id}, tweet_params)
    case Repo.insert(changeset) do
      {:ok, _tweet} ->
        conn
        |> put_flash(:info, "Successfully posted new tweet.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        conn
        |> render("index.html", user: user, changeset: changeset)
    end
  end

  defp is_authorized?(conn, _default) do
    if conn.assigns[:user].id === conn.assigns[:current_user].id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(App.ErrorView, "401.html")
    end
  end
end
