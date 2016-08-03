defmodule App.UserTest do
  use App.ModelCase

  alias App.User

  @valid_attrs %{
    login: "joe",
    password: "password",
    password_hash: "$2b$12$HqVSS6vSstuedGr49dgnMe.OuC1xVTXBq7qWk2NavwUuzxRUALuAS",
    name: "Joe Smith",
    email: "joe@example.com",
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
end
