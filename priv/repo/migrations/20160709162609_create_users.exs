defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string, null: false
      add :password_hash, :string, null: false
      add :name, :string, null: false
      add :email, :string
      add :profile_picture, :string, null: false

      timestamps()
    end
    create unique_index(:users, [:login])

  end
end
