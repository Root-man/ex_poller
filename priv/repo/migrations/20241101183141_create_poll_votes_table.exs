defmodule ExPoller.Repo.Migrations.CreatePollVotesTable do
  use Ecto.Migration

  def change do
    create table(:poll_votes) do
      add :poll_option_id, references(:poll_options), null: false
      add :user_id, references(:users), null: false
    end

    create unique_index(:poll_votes, [:poll_option_id, :user_id])
  end
end
