defmodule App.TweetController do
  use App.Web, :controller

  alias App.Favorite
  alias App.Retweet
  alias App.Tag
  alias App.Tagging
  alias App.Tweet

  plug App.LoginRequired when action in [:create, :delete]
  plug App.SetUser when action in [:create]

  def index(conn, _param) do
    query = Tweet |> order_by([t], [desc: t.inserted_at])
    query = case get_session conn, :current_user do
      nil ->
        query
      current_user ->
        query
        |> join(:left, [t], f in Favorite, f.user_id == ^current_user.id and f.tweet_id == t.id)
        |> join(:left, [t, f], r in Retweet, r.user_id == ^current_user.id and r.tweet_id == t.id)
        |> select([t, f, r], %{t | current_user_favorite_id: f.id, current_user_retweet_id: r.id})
    end
    tweets = Repo.all(query) |> Repo.preload(:user)
    render conn, "index.html", tweets: tweets
  end

  def create(conn, %{"tweet" => tweet_params}) do
    current_user = conn.assigns[:current_user]
    user = conn.assigns[:user]
    if user.id === current_user.id do
      Repo.transaction fn ->
        tweet_changeset = Tweet.changeset %Tweet{user_id: current_user.id}, tweet_params
        case Repo.insert tweet_changeset do
          {:ok, tweet} ->
            create_taggings(tweet)
            conn
            |> put_flash(:info, "Successfully posted new tweet")
            |> redirect(to: user_path(conn, :show, user))
          {:error, tweet_changeset} ->
            render conn, App.UserView, "show.html", user: user, changeset: tweet_changeset
        end
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render(App.ErrorView, "401.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    tweet = Repo.get!(Tweet, id) |> Repo.preload([taggings: :tag])
    if tweet.user_id === current_user.id do
      Repo.transaction fn ->
        Repo.delete! tweet
        delete_taggings(tweet)
      end
      conn
      |> put_flash(:info, "Successfully deleted tweet")
      |> redirect(to: user_path(conn, :show, current_user.id))
    else
      conn
      |> put_status(:unauthorized)
      |> render(App.ErrorView, "401.html")
      |> halt
    end
  end

  defp create_taggings(tweet) do
    tags = extract_tags(tweet.text)
    Enum.map(tags, fn(name) ->
      tag = create_or_get_tag(name)
      tagging_param = %{tag_id: tag.id, tweet_id: tweet.id}
      tagging_changeset = Tagging.changeset(%Tagging{}, tagging_param)
      Repo.insert! tagging_changeset
    end)
  end

  defp extract_tags(text) do
    Regex.scan(~r/\S*#(?<tag>:\[[^\]]|\S+)/, text, capture: :all_names) |> List.flatten
  end

  defp create_or_get_tag(name) do
    case Repo.one from t in Tag, where: ilike(t.name, ^name) do
      nil ->
        tag_param = %{name: name}
        tag_changeset = Tag.changeset(%Tag{}, tag_param)
        Repo.insert! tag_changeset
      tag ->
        tag
    end
  end

  defp delete_taggings(tweet) do
    Enum.map(tweet.taggings, fn(tagging) ->
      unless Repo.one(from t in Tagging, where: t.tag_id == ^tagging.tag.id) do
        Repo.delete! tagging.tag
      end
    end)
  end
end
