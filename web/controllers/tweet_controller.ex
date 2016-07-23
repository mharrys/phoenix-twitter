defmodule App.TweetController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Follower
  alias App.Tweet

  plug App.SetUser, [:followers, :following, :favorites] when action in [:index]
  plug App.SetUser when action in [:create, :delete]
  plug App.LoginRequired when action in [:create]
  plug :is_authorized? when action in [:create]

  def index(conn, %{"user_id" => user_id}) do
    user = conn.assigns[:user]
    changeset = Tweet.changeset(%Tweet{})
    current_user = get_session(conn, :current_user)
    follower = if current_user do
      query = from f in Follower, where: f.user_id == ^user.id and f.follower_id == ^current_user.id
      Repo.one(query)
    end
    user = if current_user do
      tweets = Repo.all Tweet
      |> where([t], t.user_id == ^user_id)
      |> join(:left, [t], f in Favorite, f.user_id == ^current_user.id and f.tweet_id == t.id)
      |> select([t, f], %{t | favorite_id: f.id})
      %{user | tweets: tweets}
    else
      user |> Repo.preload(:tweets)
    end
    render conn, "index.html", user: user, changeset: changeset, follower: follower
  end

  def create(conn, %{"tweet" => tweet_params}) do
    user = conn.assigns[:user]
    changeset = Tweet.changeset(%Tweet{user_id: user.id}, tweet_params)
    case Repo.insert(changeset) do
      {:ok, _tweet} ->
        conn
        |> put_flash(:info, "Successfully posted new tweet.")
        |> redirect(to: user_tweet_path(conn, :index, user))
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
