defmodule ExPoller.Polls.Option do
  use Ecto.Schema

  alias ExPoller.Polls.Poll

  schema "poll_options" do
    field(:text, :string)

    belongs_to(:poll, Poll)
  end
end
