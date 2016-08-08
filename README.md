![phoenix-twitter](https://github.com/mharrys/phoenix-twitter/raw/master/scrot.png)

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

From the phoenix-twitter root directory, execute the following:

    $ mix deps.get
    $ mix ecto.create
    $ mix ecto.migrate
    $ npm install
    $ mix phoenix.server

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Problems

I am unable to properly include session management and assign variables to the
connection in the test environment, this means that I could not write the
tests I wanted.

# License

GPL Version 3.
