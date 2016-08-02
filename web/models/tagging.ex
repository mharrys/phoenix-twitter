defmodule App.Tagging do
  use App.Web, :model

  alias App.Tag
  alias App.Tweet

  schema "taggings" do
    belongs_to :tag, Tag
    belongs_to :tweet, Tweet

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tag_id, :tweet_id])
    |> unique_constraint(:taggings_pair, name: :taggings_tag_id_tweet_id_index)
  end
end
