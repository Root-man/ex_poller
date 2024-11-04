defmodule ExPoller.Polls.Vote do
  use Ecto.Schema

  alias ExPoller.Accounts.User
  alias ExPoller.Polls.Option

  schema "poll_votes" do
    belongs_to(:user, User)
    belongs_to(:option, Option)
  end
end
