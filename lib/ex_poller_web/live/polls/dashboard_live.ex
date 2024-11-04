defmodule ExPollerWeb.Polls.DashboardLive do
  use ExPollerWeb, :live_view

  @default_polls [
    %{id: 1, title: "First", description: "Blah blah blah", user: %{email: "reeeeqmd@gmail.com"}},
    %{id: 2, title: "Second", description: nil, user: %{email: "bob@bob.bob"}},
    %{
      id: 3,
      title: "Third",
      description:
        "FUCKFUCKF UCKFUCKFUCKF UCKFUCKF UCKFUCKFUCKFUCKFUC KFUCKFUCKFUC KFUCKFUC KFUCKFUCKFUCKF UCKFUCKFUC KFUCKFU KFUCKFUCKFU CKFUCKFUCK FUCKFUC KFUCKFUCK UCKFUCK",
      user: %{email: "bob@bob.bob"}
    },
    %{id: 4, title: "Fourth", description: "FUCK", user: %{email: "bob@bob.bob"}},
    %{id: 5, title: "Fifth", description: "FUCK", user: %{email: "bob@bob.bob"}}
  ]

  def render(assigns) do
    ~H"""
    <div class="mx-auto">
      <div class="grid grid-cols-2 md:grid-cols-2 gap-10">
        <%= for poll <- @polls do %>
          <.poll_card poll={poll} />
        <% end %>
      </div>
    </div>
    """
  end

  defp poll_card(assigns) do
    ~H"""
    <div
      phx-click="select-poll"
      phx-value-id={@poll.id}
      class="block max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-100 hover:cursor-pointer dark:bg-gray-800 dark:border-gray-700 dark:hover:bg-gray-700"
    >
      <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        <%= @poll.title %>
      </h5>
      <p class="text-green-500 text-nowrap font-semibold">Created by: <%= @poll.user.email %></p>
      <p class="font-normal text-gray-700 dark:text-gray-400">
        <%= @poll.description %>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, polls: @default_polls)}
  end

  def handle_event("select-poll", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/details/#{id}")}
  end
end
