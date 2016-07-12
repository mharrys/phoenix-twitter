defmodule App.ProfileController do
  use App.Web, :controller

  def index(conn, %{"login" => login}) do
    case Repo.get_by(User, login: login) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(ErrorView, "404.html")
      user ->
        user_tweets = Repo.preload user, [:tweets]
        changeset = Tweet.changeset(%Tweet{})
        conn
        |> render("index.html", user: user_tweets, changeset: changeset)
    end
  end

  def tweet(conn, %{"login" => login, "tweet" => tweet_params}) do
    case Repo.get_by(User, login: login) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(ErrorView, "404.html")
      user ->
        authenticated = App.Authenticator.get_user(conn)
        if authenticated == nil || user.id != authenticated.id do
          conn
          |> put_flash(:error, "You are not allowed to post.")
          |> redirect(to: profile_path(conn, :index, login))
        else
          changeset = Tweet.changeset(%Tweet{user_id: user.id}, tweet_params)
          case Repo.insert(changeset) do
            {:ok, tweet} ->
              conn
              |> put_flash(:info, "Successfully posted new tweet.")
              |> redirect(to: profile_path(conn, :index, login))
            {:error, changeset} ->
              user_tweets = Repo.preload user, [:tweets]
              render conn, "index.html", user: user_tweets, changeset: changeset
          end
        end
    end
  end
end
