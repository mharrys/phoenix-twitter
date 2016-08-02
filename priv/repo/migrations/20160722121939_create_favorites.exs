defmodule App.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :tweet_id, references(:tweets, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create unique_index(:favorites, [:user_id, :tweet_id])

  end
end
