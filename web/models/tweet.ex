defmodule App.Tweet do
  use App.Web, :model

  schema "tweets" do
    field :text, :string, size: 140
    belongs_to :user, App.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
    |> validate_length(:field, min: 1, max: 140)
  end
end
