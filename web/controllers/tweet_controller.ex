defmodule App.TweetController do
  use App.Web, :controller

  alias App.Follower
  alias App.Tweet

  plug App.SetUser, [:tweets, :followers, :following]
  plug App.LoginRequired when action in [:create]
  plug :is_authorized? when action in [:create]

  def index(conn, _params) do
    user = conn.assigns[:user]
    changeset = Tweet.changeset(%Tweet{})
    current_user = get_session(conn, :current_user)
    follower = if current_user do
      query = from f in Follower, where: f.user_id == ^user.id and
                                         f.follower_id == ^current_user.id
      Repo.one(query)
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
