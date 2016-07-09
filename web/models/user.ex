defmodule App.User do
  use App.Web, :model

  schema "users" do
    field :login, :string
    field :password_hash, :string
    field :name, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:login, :password_hash, :name, :email])
    |> validate_required([:login, :password_hash, :name])
    |> unique_constraint(:email)
  end
end
