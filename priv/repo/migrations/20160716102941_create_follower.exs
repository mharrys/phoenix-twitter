defmodule App.Repo.Migrations.CreateFollower do
  use Ecto.Migration

  def change do
    create table(:followers) do
      add :user_id, references(:users, on_delete: :nothing)
      add :follower_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:followers, [:user_id, :follower_id])

  end
end
