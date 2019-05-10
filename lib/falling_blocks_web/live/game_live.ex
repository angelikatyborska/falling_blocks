defmodule FallingBlocksWeb.GameLive do
  use Phoenix.LiveView

  alias FallingBlocks.{Game, Board}

  @impl true
  def render(assigns) do
    ~L"""
    <div class="game">
      <div class="board" phx-keydown="keydown" phx-keyup="keyup" phx-target="window">
        <%= Enum.map((0..(@game_state.board.height - 1)), fn row -> %>
        <div class="board-row">
          <%= Enum.map((0..(@game_state.board.width - 1)), fn column -> %>
          <% block_type = Board.block_type_at(@game_state.board, {column, row}) %>
          <div class="block-part block-part--<%= block_type || "nil" %>"></div>
          <% end) %>
        </div>
        <% end) %>

        <%= if @game_state.state == :game_over do %>
          <%= FallingBlocksWeb.GameComponentView.render("game_over.html") %>
        <% end %>

        <%= if @game_state.state == :new do %>
          <%= FallingBlocksWeb.GameComponentView.render("controls.html") %>
        <% end %>
      </div>

      <div class="panel">
        <h1>Falling Tiles</h1>
        <div class="panel-box">
          <h3 class="panel-box-title">Next</h3>
          <div class="panel-box-content">
            <%= FallingBlocksWeb.GameComponentView.render("queue.html", queue: @game_state.block_queue) %>
          </div>
        </div>
        <div class="panel-box">
          <h3 class="panel-box-title">Lines</h3>
          <div class="panel-box-content lines"><%= @game_state.lines %></div>
        </div>
      </div>
    </div>

    <div>
      TODO:
      <ul>
        <li>pause</li>
        <li>gen server tests</li>
        <li>high score in cookies</li>
        <li>finish design</li>
        <li>rename to Falling Tiles</li>
      </ul>
    </div>
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
        assign(socket, :game_state, Game.new_dummy_game())
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("keydown", "ArrowLeft", socket) do
    :ok = Game.move(socket.assigns.game, :left)
    {:noreply, socket}
  end

  @impl true
  def handle_event("keydown", "ArrowRight", socket) do
    :ok = Game.move(socket.assigns.game, :right)
    {:noreply, socket}
  end

  @impl true
  def handle_event("keydown", "ArrowDown", socket) do
    case socket.assigns.game_state.state do
      :new ->
        :ok = Game.start(socket.assigns.game)

      :running ->
        :ok = Game.fast_mode_on(socket.assigns.game)

      :game_over ->
        :ok = Game.restart(socket.assigns.game)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("keydown", "ArrowUp", socket) do
    :ok = Game.rotate(socket.assigns.game)
    {:noreply, socket}
  end

  @impl true
  def handle_event("keydown", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("keyup", "ArrowDown", socket) do
    case socket.assigns.game_state.state do
      :running ->
        :ok = Game.fast_mode_off(socket.assigns.game)

      _ ->
        :ok
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("keyup", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info(game_state, socket) do
    socket = assign(socket, :game_state, game_state)
    {:noreply, socket}
  end
end
