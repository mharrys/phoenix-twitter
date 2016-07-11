defmodule App.LayoutView do
  use App.Web, :view

  import Plug.Conn, only: [get_session: 2]

  alias App.User
  alias App.Repo

  def current_user(conn) do
    id = get_session(conn, :id)
    if id, do: Repo.get(User, id)
  end
end
