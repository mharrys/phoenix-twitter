defmodule App.Favorite do
  use App.Web, :model

  schema "favorites" do
    belongs_to :user, App.User
    belongs_to :tweet, App.Tweet

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :tweet_id])
    |> unique_constraint(:favorites_pair, name: :favorites_user_id_tweet_id_index)
  end
end
