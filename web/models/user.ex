defmodule App.User do
  use App.Web, :model

  schema "users" do
    field :login, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :email, :string
    has_many :tweets, App.Tweet
    has_many :followers, App.Follower, foreign_key: :user_id
    has_many :following, App.Follower, foreign_key: :follower_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:login, :password, :password_hash, :name, :email])
    |> validate_required([:login, :password, :name])
    |> validate_length(:login, max: 15)
    |> validate_length(:name, max: 20)
    |> unique_constraint(:login)
    |> unique_constraint(:email)
  end

  @doc """
  Populates changeset with password hash from password.

  It will automatically generate a salt before hashing the password.
  """
  def with_password_hash(changeset) do
    password = changeset.params["password"]
    hash = Comeonin.Bcrypt.hashpwsalt(password)
    Ecto.Changeset.put_change(changeset, :password_hash, hash)
  end

  @doc """
  Validate password against hash.
  """
  def validate_password(password, hash) do
    Comeonin.Bcrypt.checkpw(password, hash)
  end
end
