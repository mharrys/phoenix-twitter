defmodule App.Authenticator do
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import App.Router.Helpers, only: [page_path: 2]
  import Plug.Conn, only: [get_session: 2, halt: 1]

  alias App.Repo
  alias App.User

  @doc """
  Find authenticated user from session.
  """
  def find_user(conn) do
    id = get_session(conn, :id)
    if id, do: {:ok, Repo.get(User, id)}, else: :error
  end

  @doc """
  Redirect user to root if already authenticated, otherwise continue as
  normal.
  """
  def redirect_authenticated(conn, _headers) do
    id = get_session(conn, :id)
    if id do
      conn
      |> put_flash(:info, "You are already logged in.")
      |> redirect(to: page_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
