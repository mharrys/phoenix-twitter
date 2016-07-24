defmodule App.User do
  use App.Web, :model

  schema "users" do
    field :login, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :new_password, :string, virtual: true
    field :new_password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :email, :string
    field :follower_id, :integer, virtual: true
    has_many :tweets, App.Tweet
    has_many :followers, App.Follower, foreign_key: :user_id
    has_many :following, App.Follower, foreign_key: :follower_id
    has_many :favorites, App.Favorite, foreign_key: :user_id
    has_many :retweets, App.Retweet, foreign_key: :user_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:login, :password, :password_hash, :new_password, :name, :email])
    |> validate_required([:login, :password, :name])
    |> validate_length(:login, max: 15)
    |> validate_length(:name, max: 20)
    |> validate_confirmation(:password)
    |> validate_confirmation(:new_password)
    |> unique_constraint(:login)
  end

  @doc """
  Populates changeset with password hash from password.

  It will automatically generate a salt before hashing the password.
  """
  def with_password_hash(changeset) do
    password = Ecto.Changeset.get_change(changeset, :password)
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
