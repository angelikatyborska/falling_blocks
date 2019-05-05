defmodule FallingBlocks.Game do
  use GenServer

  require Logger

  alias FallingBlocks.{Board, BlockQueue}

  defstruct board: nil, subscriber: nil, state: :new, block_queue: nil, lines: 0

  @type state :: :new | :running | :over
  @type t() :: %__MODULE__{
          board: Board.t(),
          subscriber: pid(),
          state: state(),
          block_queue: BlockQueue.t(),
          lines: integer()
        }
  @tick 500

  # API ######################################################

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @spec start(pid()) :: :ok
  def start(pid) do
    GenServer.call(pid, :start)
  end

  @spec get_state(pid()) :: __MODULE__.t()
  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  @spec move(pid(), Board.direction()) :: :ok
  def move(pid, direction) do
    GenServer.call(pid, {:move, direction})
  end

  @spec rotate(pid()) :: :ok
  def rotate(pid) do
    GenServer.call(pid, :rotate)
  end

  @spec advance(pid()) :: :ok
  def advance(pid) do
    GenServer.call(pid, :advance)
  end

  # This is only exposed so that the LiveView can render a new game during the initial HTTP-only connection
  # without starting the game process.
  def new_game() do
    # TODO: rethink this, the queue is random and due to the double-render it will be recreated
    queue = BlockQueue.new()
    board = %Board{height: 20, width: 10, static_blocks: []}

    %__MODULE__{board: board, block_queue: queue}
  end

  # Callbacks ######################################################

  @impl true
  def init(:ok) do
    {:ok, new_game()}
  end

  @impl true
  def handle_call(:start, {from_pid, _from_ref}, game) do
    if game.state == :new do
      {block_type, queue} = BlockQueue.pop(game.block_queue)
      {:ok, board} = Board.set_falling_block(game.board, block_type)
      send(self(), :inform_subscriber)
      :timer.send_interval(@tick, self(), :tick)

      {:reply, :ok,
       %{game | state: :running, subscriber: from_pid, board: board, block_queue: queue}}
    else
      {:reply, :ok, game}
    end
  end

  @impl true
  def handle_call(:get_state, _from, game) do
    {:reply, game, game}
  end

  @impl true
  def handle_call({:move, direction}, _from, game) do
    if game.state == :running do
      new_board = Board.move(game.board, direction)

      send(self(), :inform_subscriber)
      {:reply, :ok, %{game | board: new_board}}
    else
      {:reply, :ok, game}
    end
  end

  @impl true
  def handle_call(:rotate, _from, game) do
    if game.state == :running do
      new_board = Board.rotate(game.board)

      send(self(), :inform_subscriber)
      {:reply, :ok, %{game | board: new_board}}
    else
      {:reply, :ok, game}
    end
  end

  @impl true
  def handle_call(:advance, _from, game) do
    game = do_advance(game)
    {:reply, :ok, game}
  end

  @impl true
  def handle_info(:tick, game) do
    game = do_advance(game)
    {:noreply, game}
  end

  @impl true
  def handle_info(:inform_subscriber, game) do
    if game.subscriber do
      send(game.subscriber, game)
    end

    {:noreply, game}
  end

  @impl true
  def handle_info(message, game) do
    Logger.warn("Unexpected message: #{inspect(message)}")
    {:noreply, game}
  end

  defp do_advance(game) do
    if game.state == :running do
      game =
        if game.board.falling_block do
          {new_board, rows_cleared} = Board.advance(game.board)
          %{game | board: new_board, lines: game.lines + rows_cleared}
        else
          {block_type, queue} = BlockQueue.pop(game.block_queue)

          case Board.set_falling_block(game.board, block_type) do
            {:ok, board} ->
              %{game | board: board, block_queue: queue}

            {:game_over, board} ->
              %{game | state: :over, board: board, block_queue: queue}
          end
        end

      send(self(), :inform_subscriber)

      game
    else
      game
    end
  end
end
