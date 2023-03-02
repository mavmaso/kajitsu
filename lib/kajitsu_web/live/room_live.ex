defmodule KajitsuWeb.RoomLive do
  use KajitsuWeb, :live_view

  alias KajitsuWeb.Endpoint
  alias Kajitsu.Room

  def mount(params, session, socket) do
    name = session["name"] || params["n"]
    topic = "room: #{name}"

    if connected?(socket), do: Endpoint.subscribe(topic)

    case Room.whereis(name) do
      nil ->
        {:ok, redirect(socket, to: "/")}

      _pid ->
        socket =
          assign(socket,
            name: name,
            topic: topic,
            user: session["_csrf_token"],
            set: Room.get(name)[:users],
            cards: [],
            room: name
          )

        {:ok, socket}
    end
  end

  # def handle_params(_, _url, socket) do
  #   {:noreply, socket}
  # end

  def handle_event("vote", %{"points" => points}, socket) do
    state = Room.update_votes(socket.assigns.name, socket.assigns.user, points)
    Endpoint.broadcast(socket.assigns.topic, "points", state.votes)

    {:noreply, socket}
  end

  def handle_info(%{event: "points", payload: value}, socket) do
    {:noreply, assign(socket, cards: Map.values(value))}
  end
end
