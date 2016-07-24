defmodule App.UserController do
  use App.Web, :controller

  alias App.Follower
  alias App.Favorite
  alias App.Tweet
  alias App.User

  import Ecto.Changeset

  def index(conn, _params) do
    users = Repo.all User
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    current_user = get_session(conn, :current_user)

    query = User |> where([u], u.id == ^id)
    query = if current_user do
        query
        |> join(:left, [u], f in Follower, f.user_id == ^id and f.follower_id == ^current_user.id)
        |> select([u, f], %{u | follower_id: f.id})
    else
        query
    end
    user = Repo.one query |> preload([:followers, :following, :favorites])

    unless user do
      conn
      |> put_status(:not_found)
      |> render(App.ErrorView, "404.html")
      |> halt
    end

    user = if current_user do
      tweets = Repo.all Tweet
      |> where([t], t.user_id == ^user.id)
      |> join(:left, [t], f in Favorite, f.user_id == ^current_user.id and f.tweet_id == t.id)
      |> select([t, f], %{t | favorite_id: f.id})
      %{user | tweets: tweets}
    else
      user |> Repo.preload(:tweets)
    end

    changeset = Tweet.changeset(%Tweet{})
    render conn, "show.html", user: user, changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    # authorize user update
    password = get_change(changeset, :password)
    unless User.validate_password(password, user.password_hash) do
      render conn, "edit.html", user: user, changeset: %{changeset | action: :update }
                                                       |> add_error(:password, "wrong password")
    end

    # set new password? (optional)
    new_password = get_change(changeset, :new_password)
    changeset = if String.length(new_password) > 0 do
      put_change(changeset, :password, new_password) |> User.with_password_hash
    else
      changeset
    end

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Settings updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
