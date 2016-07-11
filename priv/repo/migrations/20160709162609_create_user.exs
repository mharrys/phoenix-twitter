defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string, null: false
      add :password_hash, :string, null: false
      add :name, :string, null: false
      add :email, :string

      timestamps()
    end
    create unique_index(:users, [:login])
    create unique_index(:users, [:email])

  end
end
