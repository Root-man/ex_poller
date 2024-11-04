defmodule ExPollerWeb.Polls.DetailsLive do
  use ExPollerWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="block mx-auto p-8 bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-100 dark:bg-gray-800 dark:border-gray-700 dark:hover:bg-gray-700 divide-y">
      <div>
        <div class="flex items-center justify-between">
          <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
            <%= @poll.title %>
          </h5>
          <.link
            navigate={~p"/dashboard"}
            class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
          >
            <.icon name="hero-arrow-left-solid" class="h-3 w-3" /> Back to the dashboard
          </.link>
        </div>
        <p class="text-green-500 text-nowrap font-semibold pt-4">
          Created by: <%= @poll.user.email %>
        </p>
        <p class="font-normal text-gray-700 dark:text-gray-400 pb-2">
          <%= @poll.description %>
        </p>
      </div>
      <div class="gap-8 pt-4">
        <%= for option <- @poll.options do %>
          <div class="flex items-center justify-between">
            <dl class="flex-grow p-2">
              <dt class="text-sm font-medium text-gray-500 dark:text-gray-400"><%= option.text %></dt>
              <dd class="flex items-center mb-3">
                <div class="w-full bg-gray-200 rounded h-10 dark:bg-gray-700 me-2">
                  <div
                    class="bg-blue-300 h-10 rounded dark:bg-blue-500 flex items-center ps-4"
                    style={"width: #{option_votes_percentage(option, @total_votes)}%"}
                  >
                    <%= option.votes_count %> out of <%= @total_votes %>
                  </div>
                </div>
                <.button
                  id="vote-button"
                  class="flex-none"
                  phx-click="vote"
                  phx-value-option-id={option.id}
                >
                  Vote!
                </.button>
              </dd>
            </dl>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(params, _session, socket) do
    poll = load_poll(params["id"])
    total_votes = count_total_votes(poll)
    {:ok, assign(socket, poll: poll, total_votes: total_votes)}
  end

  def handle_event("vote", %{"option-id" => option_id}, socket) do
    poll = socket.assigns.poll
    total_votes = socket.assigns.total_votes

    option_idx = Enum.find_index(poll.options, &(&1.id == String.to_integer(option_id)))
    option = Enum.at(poll.options, option_idx)
    option = Map.update(option, :votes_count, 0, &(&1 + 1))
    options = List.replace_at(poll.options, option_idx, option)
    {:noreply, assign(socket, total_votes: total_votes + 1, poll: Map.put(poll, :options, options))}
  end

  defp load_poll(id) do
    %{
      id: id,
      title: "What is the best programming languge for fullstack developers?",
      description:
        "Different people have different opinions on this topic. What do you think? Share your comments in twitter!",
      user: %{email: "bob@bob.bob"},
      options: [
        %{id: 1, text: "Elixir", votes_count: 1},
        %{id: 2, text: "Golang", votes_count: 2},
        %{id: 3, text: "ASM", votes_count: 3},
        %{
          id: 4,
          text:
            "Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long Long",
          votes_count: 4
        }
      ]
    }
  end

  defp count_total_votes(poll) do
    Enum.reduce(poll.options, 0, fn opt, acc -> acc + opt.votes_count end)
  end

  defp option_votes_percentage(option, total_votes) do
    (option.votes_count / total_votes * 100) |> Float.floor(0)
  end
end
