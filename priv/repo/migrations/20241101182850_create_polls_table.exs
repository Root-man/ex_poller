defmodule ExPoller.Repo.Migrations.CreatePollsTable do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :name, :string, null: false
      add :description, :text
      add :user_id, references(:users), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
