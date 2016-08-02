defmodule App.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :tweet_id, references(:tweets, on_delete: :delete_all)

      timestamps()
    end
    create unique_index(:taggings, [:tag_id, :tweet_id])
  end
end
