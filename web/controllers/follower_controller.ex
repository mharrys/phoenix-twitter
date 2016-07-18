defmodule App.FollowerController do
  use App.Web, :controller

  alias App.Follower

  plug App.SetUser, [:followers] when action in [:followers]
  plug App.SetUser, [:following] when action in [:following]
  plug App.LoginRequired when action in [:follow, :unfollow]
  plug App.SetUser when action in [:follow, :unfollow]
  plug :not_a_follower when action in [:follow]
  plug :user_is_not_current_user when action in [:follow, :unfollow]

  def followers(conn, _param) do
    user = conn.assigns[:user]
    followers = user.followers |> Repo.preload(:follower)
    render conn, "followers.html", user: user, followers: followers
  end

  def following(conn, _param) do
    user = conn.assigns[:user]
    following = user.following |> Repo.preload(:user)
    render conn, "following.html", user: user, following: following
  end

  def follow(conn, _param) do
    user = conn.assigns[:user]
    current_user = conn.assigns[:current_user]
    follower = %Follower{user_id: user.id, follower_id: current_user.id}
    case Repo.insert(Follower.changeset(follower, %{})) do
      {:ok, _follower} ->
        redirect(conn, to: user_tweet_path(conn, :index, user.id))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to follow.")
        |> redirect(to: user_tweet_path(conn, :index, user.id))
        |> halt
    end
  end

  def unfollow(conn, %{"id" => id}) do
    user = conn.assigns[:user]
    follower = Repo.get!(Follower, id)
    Repo.delete!(follower)
    redirect(conn, to: user_tweet_path(conn, :index, user.id))
  end

  defp not_a_follower(conn, _default) do
    user = conn.assigns[:user]
    current_user = conn.assigns[:current_user]
    query = from f in Follower, where: f.user_id == ^user.id and f.follower_id == ^current_user.id
    if Repo.one(query) do
      conn
      |> put_flash(:error, "Already following.")
      |> redirect(to: user_tweet_path(conn, :index, user.id))
      |> halt
    else
      conn
    end
  end

  defp user_is_not_current_user(conn, _default) do
    user = conn.assigns[:user]
    current_user = conn.assigns[:current_user]
    if user.id === current_user.id do
      conn
      |> put_flash(:error, "Unable to follow.")
      |> redirect(to: user_tweet_path(conn, :index, user.id))
      |> halt
    else
      conn
    end
  end
end
