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
    <div class="mx-auto max-w-sm md:max-w-3xl">
      <div class="pb-4">
        <.button phx-click={show_modal("create-poll-modal")} class="w-full">Create new poll</.button>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
        <%= for poll <- @polls do %>
          <.poll_card poll={poll} />
        <% end %>
      </div>
      <.modal id="create-poll-modal">
        <div class="divide-y grid">
          <h3 class="text-xl font-semibold text-gray-900 dark:text-white pb-4">Create a new poll</h3>
          <div class="py-6">
            <.simple_form for={@form} phx-change="validate" phx-submit="submit">
              <.input field={@form[:name]} label="Poll name" />
              <.input field={@form[:description]} label="Description" />

              <:actions>
                <.button>Create</.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </.modal>
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

  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:description, :string)

  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :description])
    |> validate_length(:name, min: 10, max: 255)
    |> validate_length(:description, max: 500)
  end

  @spec mount(any(), any(), any()) :: {:ok, any()}
  def mount(_params, _session, socket) do
    changeset = changeset(%{})
    form = to_form(changeset)
    {:ok, assign(socket, polls: @default_polls, form: form, changeset: changeset)}
  end

  def handle_event("select-poll", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/details/#{id}")}
  end

  def handle_event("validate", %{"dashboard_live" => params}, socket) do
    {:noreply, assign(socket, changeset: changeset(params))}
  end

  def handle_event("submit", %{"dashboard_live" => params}, socket) do
    changeset = changeset(params)

    if changeset.valid? do
      dbg(changeset)
      {:noreply, socket}
    else
      dbg(to_form(changeset))
      {:noreply, assign(socket, changeset: changeset, form: to_form(changeset))}
    end
  end
end
