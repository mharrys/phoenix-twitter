defmodule App.SharedView do
  use App.Web, :view

  @months %{1 => gettext("Jan"), 2 => gettext("Feb"), 3 => gettext("Mar"),  4 => gettext("Apr"),  5 => gettext("May"),  6 => gettext("Jun"),
            7 => gettext("Jul"), 8 => gettext("Aug"), 9 => gettext("Sep"), 10 => gettext("Oct"), 11 => gettext("Nov"), 12 => gettext("Dec")}

  def format_datetime({{y, m, d}, _}) do
    String.Chars.to_string(:io_lib.format("~s ~p, ~p", [@months[m], d, y]))
  end

  def format_datetime(datetime) do
    {:ok, dump} = Ecto.DateTime.dump(datetime)
    format_datetime(dump)
  end

  def authenticated(conn) do
    current_user(conn) != nil
  end
end
