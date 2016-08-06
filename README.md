# Phoenix-Twitter

A small twitter clone created with Elixir and Phoenix Framework that has the
following features:

  * Signup and login a user
  * Update user settings
  * Upload profile picture
  * Post tweet (can include user mentions and hashtags)
  * Post retweets
  * Favorite tweet
  * Follow other users
  * Clickable user mention links
  * Clickable hashtags to view all tweets with that hashtag
  * Swedish translation

There are some Postgres spcific SQL commands since there is no union
functionality in Ecto. The CSS is done with [SASS](http://sass-lang.com/) and
[bootstrap-sass](https://github.com/twbs/bootstrap-sass) with the addition of
[Font Awesome](http://fontawesome.io/).

# How-to

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Problems

I am unable to properly include session management and assign variables to the
connection in the test environment, this means that I could not write the
tests I wanted.

# License

GPL Version 3.
