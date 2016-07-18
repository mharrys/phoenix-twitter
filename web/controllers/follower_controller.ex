defmodule App.FollowerController do
  use App.Web, :controller

  alias App.Follower

  plug App.SetUser, [:followers] when action in [:followers]
  plug App.SetUser, [:following] when action in [:following]

  def followers(conn, %{"user_id" => user_id}) do
    user = conn.assigns[:user]
    followers = user.followers |> Repo.preload(:follower)
    render conn, "followers.html", user: user, followers: followers
  end

  def following(conn, %{"user_id" => user_id}) do
    user = conn.assigns[:user]
    following = user.following |> Repo.preload(:user)
    render conn, "following.html", user: user, following: following
  end

  def follow(conn, %{"user_id" => user_id}) do
    {user_id, _} = Integer.parse(user_id)
    follower_id = get_session(conn, :current_user).id
    follower = %Follower{user_id: user_id, follower_id: follower_id}
    case Repo.insert(Follower.changeset(follower, %{})) do
      {:ok, _follower} ->
        redirect(conn, to: user_tweet_path(conn, :index, user_id))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to follow.")
        |> redirect(to: user_tweet_path(conn, :index, user_id))
    end
  end

  def unfollow(conn, %{"user_id" => user_id, "id" => id}) do
    follower = Repo.get!(Follower, id)
    Repo.delete!(follower)
    redirect(conn, to: user_tweet_path(conn, :index, user_id))
  end
end
