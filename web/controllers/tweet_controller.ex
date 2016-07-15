defmodule App.TweetController do
  use App.Web, :controller

  import App.Authenticator, [:find_user]
  import Plug.Conn

  plug :set_user
  plug :set_current_user

  def index(conn, _params) do
    user = conn.assigns[:user] |> Repo.preload([:tweets])
    current_user = conn.assigns[:current_user]
    changeset = Tweet.changeset(%Tweet{})
    render conn, "index.html", user: user, current_user: current_user, changeset: changeset
  end

  def create(conn, %{"tweet" => tweet_params}) do
    user = conn.assigns[:user] |> Repo.preload([:tweets])
    current_user = conn.assigns[:current_user]
    changeset = Tweet.changeset(%Tweet{user_id: user.id}, tweet_params)
    case Repo.insert(changeset) do
      {:ok, _tweet} ->
        conn
        |> put_flash(:info, "Successfully posted new tweet.")
        |> redirect(to: user_tweet_path(conn, :index, user.id))
      {:error, changeset} ->
        conn
        |> render("index.html", user: user, current_user: current_user, changeset: changeset)
    end
  end

  defp set_user(%Plug.Conn{params: %{"user_id" => user_id}} = conn, _default) do
    case Repo.get(User, user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(App.ErrorView, "404.html")
      user ->
        assign conn, :user, user
    end
  end

  defp set_current_user(conn, _default) do
    case find_user(conn) do
      {:ok, current_user} ->
        assign(conn, :current_user, current_user)
      :error ->
        conn
    end
  end
end
