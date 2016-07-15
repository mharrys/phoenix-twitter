defmodule App.RedirectAuthenticated do
  @moduledoc """
  The responsibility of this plug is to route already authenticated user to
  root, otherwise continue as normal.
  """
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn, only: [get_session: 2, halt: 1]
  import App.Router.Helpers, only: [page_path: 2]

  def init(default), do: default

  def call(conn, _default) do
    if get_session(conn, :current_user) do
      conn
      |> put_flash(:info, "You are already logged in.")
      |> redirect(to: page_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
