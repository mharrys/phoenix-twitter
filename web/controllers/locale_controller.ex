defmodule App.LocaleController do
  use App.Web, :controller

  def new(conn, %{"locale" => locale}) do
    Gettext.put_locale(App.Gettext, locale)
    conn
    |> put_session(:locale, locale)
    |> redirect(to: page_path(conn, :index))
  end
end
