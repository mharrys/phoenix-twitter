defmodule App.SharedView do
  use App.Web, :view

  @months %{1 => "Jan", 2 => "Feb", 3 => "Mar",  4 => "Apr",  5 => "May",  6 => "Jun",
            7 => "Jul", 8 => "Aug", 9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec"}

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
