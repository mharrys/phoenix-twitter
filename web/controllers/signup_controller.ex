defmodule App.SignupController do
  use App.Web, :controller

  alias App.User

  import Ecto.Changeset

  plug App.RedirectAuthenticated

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "index.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params) |> User.with_password_hash
    changeset = put_change(changeset, :profile_picture, "default_profile.png")
    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_session(:current_user, %{id: user.id, login: user.login, name: user.name})
        |> put_flash(:info, "Successfully created user account")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render conn, "index.html", changeset: changeset
    end
  end
end
