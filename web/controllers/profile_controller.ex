defmodule App.ProfileController do
  use App.Web, :controller

  import App.Authenticator

  plug :login_required
  plug :preload_tweets

  def index(conn, _params) do
    user = conn.assigns[:user]
    changeset = Tweet.changeset(%Tweet{})
    render conn, "index.html", user: user, changeset: changeset
  end

  def create(conn, %{"tweet" => tweet_params}) do
    user = conn.assigns[:user]
    changeset = Tweet.changeset(%Tweet{user_id: user.id}, tweet_params)
    case Repo.insert(changeset) do
      {:ok, tweet} ->
        conn
        |> put_flash(:info, "Successfully posted new tweet.")
        |> redirect(to: profile_path(conn, :index))
      {:error, changeset} ->
        render conn, "index.html", user: user, changeset: changeset
    end
  end

  defp preload_tweets(conn, _headers) do
    user = conn.assigns[:user]
    assign(conn, :user, Repo.preload(user, [:tweets]))
  end
end
