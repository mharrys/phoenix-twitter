defmodule App.FollowerController do
  use App.Web, :controller

  alias App.Follower

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
