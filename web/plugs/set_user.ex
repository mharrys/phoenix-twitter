defmodule App.SetUser do
  @moduledoc """
  The responsibility of this plug is to assign the user to the connection from
  specified user id, or throw 404. The default parameter allows for preloading
  extra user associations.
  """
  use App.Web, :controller

  alias App.Follower
  alias App.User
  alias App.Tweet

  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{params: %{"id" => id}} = conn, _default) do
    run(conn, id)
  end

  def call(%Plug.Conn{params: %{"user_id" => user_id}} = conn, _default) do
    run(conn, user_id)
  end

  defp run(conn, user_id) do
    user_id = try do
      String.to_integer(user_id)
    rescue
      _ in ArgumentError -> 0
    end
    current_user = User.get_current_user conn
    query = User |> where([u], u.id == ^user_id)
    query = if current_user do
      query
      |> join(:left, [u], f in Follower, f.user_id == ^user_id and f.follower_id == ^current_user.id)
      |> select([u, f], %{u | follower_id: f.id})
    else
      query
    end
    case Repo.one query do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(App.ErrorView, "404.html")
        |> halt
      user ->
        current_user_id = if current_user do current_user.id end
        tweets = fetch_user_tweets(user_id, current_user_id) |> Repo.preload(:user)
        user = %{user | tweets: tweets} |> Repo.preload([:followers, :following, :favorites])
        assign conn, :user, user
    end
  end

  defp fetch_user_tweets(id, current_user_id) do
    {:ok, result} = Ecto.Adapters.SQL.query(Repo, "SELECT * FROM fetch_user_tweets($1, $2)", [id, current_user_id])
    Enum.map(result.rows, fn([id, text, user_id, inserted_at, updated_at, retweet_id, current_user_favorite_id, current_user_retweet_id]) ->
      %Tweet{
        id: id,
        text: text,
        user_id: user_id,
        inserted_at: inserted_at,
        updated_at: updated_at,
        retweet_id: retweet_id,
        current_user_favorite_id: current_user_favorite_id,
        current_user_retweet_id: current_user_retweet_id}
    end)
  end
end
