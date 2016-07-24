defmodule App.Router do
  use App.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", App do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get  "/signup", SignupController, :index
    post "/signup", SignupController, :create

    get  "/login", LoginController, :index
    post "/login", LoginController, :login

    get "/logout", LogoutController, :index

    resources "/users", UserController, only: [:index, :show, :edit, :update] do
      resources "/tweets", TweetController, only: [:create]

      get "/followers", FollowerController, :followers
      get "/following", FollowerController, :following
      get "/favorites", FavoriteController, :index

      get "/follow", FollowerController, :follow
      get "/unfollow/:id", FollowerController, :unfollow
    end

    resources "/tweets", TweetController, only: [:index] do
      post   "/favorite", FavoriteController, :create
      delete "/favorite", FavoriteController, :delete
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", App do
  #   pipe_through :api
  # end
end
