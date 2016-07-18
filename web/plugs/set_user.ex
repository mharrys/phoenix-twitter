defmodule App.SetUser do
  @moduledoc """
  The responsibility of this plug is to assign the user to the connection from
  specified user id, or throw 404. The default parameter allows for preloading
  extra user associations.
  """
  use App.Web, :controller

  alias App.User

  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{params: %{"user_id" => user_id}} = conn, default) do
    case Repo.get(User, user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(App.ErrorView, "404.html")
      user ->
        assign conn, :user, user |> Repo.preload(default)
    end
  end

end
