defmodule App.LayoutView do
  use App.Web, :view

  import Plug.Conn

  def current_locale(conn) do
    conn.params["locale"] || get_session(conn, :locale)
  end
end
