defmodule FallingBlocksWeb.GameLive do
  use Phoenix.LiveView

  alias FallingBlocks.Game

  def render(assigns) do
    ~L"""
    <a phx-click="start">Start</a>

    <pre><%= inspect(@game_state.board) %></pre>
    """
  end

  def mount(_assigns, socket) do
    socket =
      if connected?(socket) do
        {:ok, game} = Game.start_link()
        Game.get_state(game)
        socket = assign(socket, :game, game)
        assign(socket, :game_state, Game.get_state(game))
      else
        assign(socket, :game_state, Game.new_game())
      end

    {:ok, socket}
  end

  def handle_event("start", _, socket) do
    :ok = Game.start(socket.assigns.game)
    {:noreply, socket}
  end

  def handle_info(game_state, socket) do
    socket = assign(socket, :game_state, game_state)
    {:noreply, socket}
  end
end
