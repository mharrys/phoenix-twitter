defmodule App.TagController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Retweet
  alias App.Tag
  alias App.Tagging
  alias App.Tweet

  def show(conn, %{"name" => name}) do
    query = Tag
    |> where([tag], ilike(tag.name, ^name))
    |> join(:left, [tag], tagging in Tagging, tagging.tag_id == tag.id)
    |> join(:left, [_, tagging], tweet in Tweet, tweet.id == tagging.tweet_id)
    query = case get_session conn, :current_user do
      nil ->
        query
        |> select([_, _, tweet], tweet)
      current_user ->
        query
        |> join(:left, [_, _, t], f in Favorite, f.user_id == ^current_user.id and f.tweet_id == t.id)
        |> join(:left, [_, _, t, f], r in Retweet, r.user_id == ^current_user.id and r.tweet_id == t.id)
        |> select([_, _, t, f, r], %{t | current_user_favorite_id: f.id, current_user_retweet_id: r.id})
    end
    tweets = Repo.all(query) |> Repo.preload(:user)
    render conn, App.TweetView, "index.html", tweets: tweets
  end
end
