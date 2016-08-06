defmodule App.RedirectAuthenticated do
  @moduledoc """
  The responsibility of this plug is to route already authenticated user to
  root, otherwise continue as normal.
  """
  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]
  import App.Router.Helpers, only: [user_path: 3]

  alias App.User

  def init(default), do: default

  def call(conn, _default) do
    case User.get_current_user conn do
      nil ->
        conn
      current_user ->
        conn
        |> redirect(to: user_path(conn, :show, current_user.id))
        |> halt
    end
  end
end
