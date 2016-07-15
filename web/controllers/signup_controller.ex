defmodule App.SignupController do
  use App.Web, :controller

  alias App.User

  import App.Authenticator, only: [redirect_authenticated: 2]

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
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully created user account.")
        |> redirect(to: user_tweet_path(conn, :index, user.id))
      {:error, changeset} ->
        render conn, "index.html", changeset: changeset
    end
  end
end
