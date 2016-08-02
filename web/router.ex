defmodule App.Router do
  use App.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", App do
    pipe_through :browser

    get "/", PageController, :index

    get  "/signup", SignupController, :index
    post "/signup", SignupController, :create

    get  "/login", LoginController, :index
    post "/login", LoginController, :login

    get "/logout", LogoutController, :index

    resources "/users", UserController, only: [:index, :show, :edit, :update] do
      resources "/tweets", TweetController, only: [:create]

      get "/followers", FollowerController, :index
      get "/following", FollowingController, :index
      get "/favorites", FavoriteController, :index

      post   "/follow", FollowerController, :create
      delete "/follow", FollowerController, :delete
    end

    resources "/tweets", TweetController, only: [:index, :delete] do
      post   "/favorite", FavoriteController, :create
      delete "/favorite", FavoriteController, :delete

      post   "/retweet", RetweetController, :create
      delete "/retweet", RetweetController, :delete
    end

    get "/hashtag/:name", TagController, :show
  end
end
