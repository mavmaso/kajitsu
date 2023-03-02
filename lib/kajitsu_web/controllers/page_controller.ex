defmodule KajitsuWeb.PageController do
  use KajitsuWeb, :controller
  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    render(conn, "index.html", changeset: :atom)
  end

  def room(conn, _params) do
    num = System.unique_integer([:positive]) |> Integer.to_string()
    Kajitsu.RoomSupervivor.create(num)

    live_render(conn, KajitsuWeb.RoomLive, session: %{"name" => num})
  end
end
