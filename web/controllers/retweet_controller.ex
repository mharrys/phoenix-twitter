defmodule App.RetweetController do
  use App.Web, :controller

  alias App.Retweet
  alias App.Tweet

  plug App.LoginRequired when action in [:create, :delete]

  def create(conn, %{"tweet_id" => tweet_id}) do
    current_user = conn.assigns[:current_user]
    tweet = Repo.get! Tweet, tweet_id
    if tweet.user_id === current_user.id do
      conn
      |> put_flash(:error, "You are not allowed to retweet your own tweets")
      |> redirect(to: user_path(conn, :show, current_user.id))
      |> halt
    else
      retweet_param = %{tweet_id: tweet.id, user_id: current_user.id}
      changeset = Retweet.changeset(%Retweet{}, retweet_param)
      Repo.insert! changeset
      redirect conn, to: user_path(conn, :show, current_user.id)
    end
  end

  def delete(conn, %{"tweet_id" => tweet_id}) do
    current_user = conn.assigns[:current_user]
    query = from f in Retweet,
            where: f.tweet_id == ^tweet_id and f.user_id == ^current_user.id
    retweet = Repo.one! query
    Repo.delete! retweet
    redirect conn, to: user_path(conn, :show, current_user.id)
  end
end
