defmodule App.Follower do
  use App.Web, :model

  schema "followers" do
    belongs_to :user, App.User
    belongs_to :follower, App.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :follower_id])
  end
end
