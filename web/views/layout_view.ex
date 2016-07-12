defmodule App.LayoutView do
  use App.Web, :view

  import App.Authenticator, only: [find_user: 1]

  def current_user(conn) do
    case find_user conn do
      {:ok, user} -> user
      :error -> nil
    end
  end
end
