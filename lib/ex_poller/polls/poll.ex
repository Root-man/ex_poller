defmodule ExPoller.Polls.Poll do
  use Ecto.Schema

  alias ExPoller.Accounts.User
  alias ExPoller.Polls.Option

  schema "polls" do
    field(:name, :string)
    field(:description, :string)

    belongs_to(:user, User)
    has_many(:options, Option)

    timestamps(type: :utc_datetime)
  end
end
