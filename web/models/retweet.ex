defmodule App.Retweet do
  use App.Web, :model

  alias App.Tweet
  alias App.User

  schema "retweets" do
    belongs_to :tweet, Tweet
    belongs_to :user, User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tweet_id, :user_id])
    |> unique_constraint(:retweets_pair, name: :retweets_tweet_id_user_id_index)
  end
end
