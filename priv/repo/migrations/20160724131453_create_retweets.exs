defmodule App.Repo.Migrations.CreateRetweetsTable do
  use Ecto.Migration

  def change do
    create table(:retweets) do
      add :tweet_id, references(:tweets, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create unique_index(:retweets, [:tweet_id, :user_id])

  end
end
