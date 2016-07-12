defmodule App.LayoutView do
  use App.Web, :view

  import App.Authenticator, only: [get_user: 1]

  def current_user(conn) do
    get_user conn
  end
end
