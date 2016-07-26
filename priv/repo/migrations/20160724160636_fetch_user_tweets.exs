defmodule App.Repo.Migrations.FetchUserTweets do
  @moduledoc """
  The responsibility of this module is to define a function for retreving user
  tweets and retweets. It is defined here since there exist no support in Ecto
  to do a UNION ALL. There exist support for executing raw SQL expressions, but
  this approach is arguably the most clean and reusable solution.
  """
  use Ecto.Migration

  def up do
    execute "
    CREATE FUNCTION fetch_user_tweets(
      _user_id integer,
      _current_user_id integer DEFAULT NULL)

    RETURNS TABLE(
      id tweets.id%TYPE,
      text tweets.text%TYPE,
      user_id tweets.user_id%TYPE,
      inserted_at tweets.inserted_at%TYPE,
      updated_at tweets.updated_at%TYPE,
      user_retweet_id retweets.id%TYPE,
      current_user_favorite_id favorites.id%TYPE,
      current_user_retweet_id retweets.id%TYPE)
    AS $$
      BEGIN
        RETURN QUERY WITH

        _tweets AS (
          SELECT t.id, t.text, t.user_id, t.inserted_at, t.updated_at, NULL AS retweet_id
          FROM tweets AS t
          WHERE t.user_id = _user_id
          UNION ALL
          SELECT t.id, t.text, t.user_id, r.inserted_at, r.updated_at, r.id AS retweet_id
          FROM retweets AS r
          LEFT OUTER JOIN tweets AS t ON t.id = r.tweet_id
          WHERE r.user_id = _user_id
        )

        SELECT t.id, t.text, t.user_id, t.inserted_at, t.updated_at, t.retweet_id, f.id AS current_user_favorite_id, r.id AS current_user_retweet_id
        FROM _tweets AS t
        LEFT OUTER JOIN favorites AS f ON (f.user_id = _current_user_id) AND (f.tweet_id = t.id)
        LEFT OUTER JOIN retweets AS r ON (r.user_id = _current_user_id) AND (r.tweet_id = t.id)
        ORDER BY inserted_at DESC;
      END;
    $$ LANGUAGE plpgsql;
    "
  end

  def down do
    execute "DROP FUNCTION fetch_user_tweets(integer, integer)"
  end
end
