defmodule App.UserTest do
  use App.ModelCase

  alias App.User
  alias App.Repo

  import Ecto.Query

  @valid_attrs %{
    login: "joe",
    name: "Joe Smith",
    email: "joe@example.com",
    password: "password",
    password_confirmation: "password",
    password_hash: "$2b$12$HqVSS6vSstuedGr49dgnMe.OuC1xVTXBq7qWk2NavwUuzxRUALuAS",
    profile_picture: "default_profile.png"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "create user" do
    user = Map.merge %User{}, @valid_attrs
    Repo.insert! user
    assert length(Repo.all(from u in User)) == 1
  end

  test "delete user" do
    user = Map.merge %User{}, @valid_attrs
    Repo.insert! user
    user = Repo.one! from u in User, where: u.login == ^user.login
    Repo.delete! user
    assert length(Repo.all(from u in User)) == 0
  end
end
