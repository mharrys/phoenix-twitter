defmodule App.UserController do
  use App.Web, :controller

  alias App.User

  import Ecto.Changeset

  def index(conn, _params) do
    users = Repo.all User
    render conn, "index.html", users: users
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
      changeset =
        %{changeset | action: :update }
        |> add_error(:password, "wrong password")
      render conn, "edit.html", user: user, changeset: changeset
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
        |> redirect(to: user_tweet_path(conn, :index, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
