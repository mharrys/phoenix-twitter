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
    user = Repo.get!(User, id) |> Repo.preload([:followers, :following, :favorites])
    changeset = Tweet.changeset(%Tweet{})
    current_user = get_session(conn, :current_user)

    follower = if current_user do
      query = from f in Follower,
              where: f.user_id == ^user.id and f.follower_id == ^current_user.id
      Repo.one(query)
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

    render conn, "show.html", user: user, changeset: changeset, follower: follower
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
