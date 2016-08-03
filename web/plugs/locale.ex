defmodule App.Locale do
  @moduledoc """
  The responsibility of this plug is to set the gettext locale if it is
  supplied in the connection.

  http://sevenseacat.net/2015/12/20/i18n-in-phoenix-apps.html
  """
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    case conn.params["locale"] || get_session(conn, :locale) do
      nil ->
        conn
      locale ->
        Gettext.put_locale(App.Gettext, locale)
        conn |> put_session(:locale, locale)
    end
  end
end
