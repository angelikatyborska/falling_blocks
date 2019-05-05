defmodule FallingBlocksWeb.GameLive do
  use Phoenix.LiveView

  alias FallingBlocks.{Game, Board}

  @impl true
  def render(assigns) do
    ~L"""
    <div class="game">
      <div class="panel panel-left">
        <div class="panel-box">
          <div class="panel-box-title">Controls</div>
          <div class="panel-box-content">
            <%= FallingBlocksWeb.GameComponentView.render("controls.html") %>
          </div>
        </div>
      </div>

      <div class="board" phx-keydown="move" phx-target="window">
        <%= Enum.map((0..(@game_state.board.height - 1)), fn row -> %>
        <div class="board-row">
          <%= Enum.map((0..(@game_state.board.width - 1)), fn column -> %>
          <% block_type = Board.block_type_at(@game_state.board, {column, row}) %>
          <div class="block-part block-part--<%= block_type %>"></div>
          <% end) %>
        </div>
        <% end) %>

        <%= if @game_state.state == :game_over do %>
          <%= FallingBlocksWeb.GameComponentView.render("game_over.html") %>
        <% end %>
      </div>

      <div class="panel">
        <h1>Falling Blocks</h1>
        <div class="panel-box">
          <div class="panel-box-title">Next</div>
          <div class="panel-box-content"><%= Enum.join(@game_state.block_queue, ", ") %></div>
        </div>
        <div class="panel-box">
          <div class="panel-box-title">Lines</div>
          <div class="panel-box-content"><%= @game_state.lines %></div>
        </div>
      </div>
    </div>

    <div>
      TODO:
      <ul>
        <li>pause</li>
        <li>improved moving</li>
        <li>high score in cookies</li>
        <li>design (azulejo?)</li>
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
    case socket.assigns.game_state.state do
      :new ->
        :ok = Game.start(socket.assigns.game)

      :running ->
        :ok = Game.advance(socket.assigns.game)

      :game_over ->
        :ok = Game.restart(socket.assigns.game)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("move", "ArrowUp", socket) do
    :ok = Game.rotate(socket.assigns.game)
    {:noreply, socket}
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
