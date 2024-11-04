defmodule ExPoller.Repo.Migrations.CreatePollOptionsTable do
  use Ecto.Migration

  def change do
    create table(:poll_options) do
      add :poll_id, references(:polls), null: false
      add :text, :string, null: false
    end
  end
end
