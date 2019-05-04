defmodule FallingBlocksWeb.GameLive do
  use Phoenix.LiveView

  alias FallingBlocks.{Game, Board}

  @impl true
  def render(assigns) do
    ~L"""
    <a phx-click="start">Start</a>

    <div>Next: <%= Enum.join(@game_state.block_queue, ", ") %></div>

    <div class="board" phx-keydown="move" phx-target="window">
      <%= Enum.map((0..(@game_state.board.height - 1)), fn row -> %>
      <div class="board-row">
        <%= Enum.map((0..(@game_state.board.width - 1)), fn column -> %>
        <% block_type = Board.block_type_at(@game_state.board, {column, row}) %>
        <div class="block-part block-part--<%= block_type %>"></div>
        <% end) %>
      </div>
      <% end) %>
    </div>

    <%= if @game_state.state == :over do %>
      <div>Game Over</div>
    <% end %>
    """
  end

  @impl true
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

  @impl true
  def handle_event("start", _, socket) do
    :ok = Game.start(socket.assigns.game)
    {:noreply, socket}
  end

  @impl true
  def handle_event("move", "ArrowLeft", socket) do
    :ok = Game.move(socket.assigns.game, :left)
    {:noreply, socket}
  end

  @impl true
  def handle_event("move", "ArrowRight", socket) do
    :ok = Game.move(socket.assigns.game, :right)
    {:noreply, socket}
  end

  @impl true
  def handle_event("move", "ArrowDown", socket) do
    if socket.assigns.game_state.state == :new do
      :ok = Game.start(socket.assigns.game)
      {:noreply, socket}
    else
      :ok = Game.advance(socket.assigns.game)
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("move", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info(game_state, socket) do
    socket = assign(socket, :game_state, game_state)
    {:noreply, socket}
  end
end
