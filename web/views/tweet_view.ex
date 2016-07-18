defmodule App.TweetView do
  use App.Web, :view

  def user_profile(conn) do
    u1 = conn.assigns[:user]
    u2 = current_user(conn)
    u1 && u2 && u1.id === u2.id
  end

  def authenticated(conn) do
    current_user(conn) != nil
  end
end
