defmodule App.Tweet do
  use App.Web, :model

  alias App.User
  alias App.Favorite
  alias App.Tagging
  alias App.Tweet

  schema "tweets" do
    field :text, :string, size: 140
    field :retweet_id, :integer, virtual: true
    field :current_user_favorite_id, :integer, virtual: true
    field :current_user_retweet_id, :integer, virtual: true
    belongs_to :user, User
    has_many :favorites, Favorite, foreign_key: :user_id
    has_many :retweets, Tweet, foreign_key: :tweet_id
    has_many :taggings, Tagging, foreign_key: :tweet_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
    |> validate_length(:text, min: 1, max: 140)
  end
end
