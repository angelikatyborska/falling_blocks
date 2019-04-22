defmodule FallingBlocks.Game do
  use GenServer

  require Logger

  alias FallingBlocks.{Board, Block}

  defstruct board: nil, subscriber: nil

  @type t() :: %__MODULE__{board: Board.t(), subscriber: pid()}
  @tick 1000

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start(pid) do
    GenServer.call(pid, :start)
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  # This is only exposed so that the LiveView can render a new game during the initial HTTP-only connection
  # without starting the game process.
  def new_game() do
    square = Block.square({4, 0})
    board = %Board{height: 20, width: 10, static_blocks: [], falling_block: square}

    %__MODULE__{board: board}
  end

  def init(:ok) do
    {:ok, new_game()}
  end

  def handle_call(:start, {from_pid, _from_ref}, game) do
    :timer.send_interval(@tick, self(), :advance)
    {:reply, :ok, %{game | subscriber: from_pid}}
  end

  def handle_call(:get_state, _from, game) do
    {:reply, game, game}
  end

  def handle_info(:advance, game) do
    new_board = Board.advance(game.board)
    send(self(), :inform_subscriber)
    {:noreply, %{game | board: new_board}}
  end

  def handle_info(:inform_subscriber, game) do
    send(game.subscriber, game)
    {:noreply, game}
  end

  def handle_info(message, game) do
    Logger.warn("Unexpected message: #{inspect(message)}")
    {:noreply, game}
  end
end
