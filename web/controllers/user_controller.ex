defmodule App.UserController do
  use App.Web, :controller

  alias App.Tweet
  alias App.User

  import Ecto.Changeset

  plug App.LoginRequired when action in [:edit, :update]
  plug App.SetUser when action in [:show]

  def index(conn, _params) do
    users = Repo.all User |> order_by([u], [asc: u.name])
    render conn, "index.html", users: users
  end

  def show(conn, _params) do
    user = conn.assigns[:user]
    changeset = Tweet.changeset %Tweet{}
    render conn, "show.html", user: user, changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get! User, id
    changeset = User.changeset user
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get! User, id
    changeset = User.changeset user, user_params

    # authorize user update
    password = get_change(changeset, :password)
    unless User.validate_password password, user.password_hash do
      new_changeset = %{changeset | action: :update } |> add_error(:password, "wrong password")
      render conn, "edit.html", user: user, changeset: new_changeset
    end

    # set new password? (optional)
    new_password = get_change changeset, :new_password
    changeset = if String.length(new_password) > 0 do
      put_change(changeset, :password, new_password) |> User.with_password_hash
    else
      changeset
    end

    case Repo.update changeset do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Settings updated successfully")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render conn, "edit.html", user: user, changeset: changeset
    end
  end
end
