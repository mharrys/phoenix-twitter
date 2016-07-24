defmodule App.Repo.Migrations.CreateRetweetsTable do
  use Ecto.Migration

  def change do
    create table(:retweets) do
      add :tweet_id, references(:tweets, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:retweets, [:tweet_id, :user_id])

  end
end
