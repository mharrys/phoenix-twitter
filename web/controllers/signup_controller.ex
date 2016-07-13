defmodule App.SignupController do
  use App.Web, :controller

  import App.Authenticator

  plug :redirect_authenticated

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "index.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params) |> User.with_password_hash
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_session(:id, user.id)
        |> put_flash(:info, "Successfully created user account.")
        |> redirect(to: profile_path(conn, :index))
      {:error, changeset} ->
        render conn, "index.html", changeset: changeset
    end
  end
end
