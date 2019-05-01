defmodule FallingBlocks.Game do
  use GenServer

  require Logger

  alias FallingBlocks.{Board, Block}

  defstruct board: nil, subscriber: nil, state: :new

  @type state :: :new | :running | :over
  @type t() :: %__MODULE__{board: Board.t(), subscriber: pid(), state: state()}
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

  @spec advance(pid()) :: :ok
  def advance(pid) do
    GenServer.call(pid, :advance)
  end

  # This is only exposed so that the LiveView can render a new game during the initial HTTP-only connection
  # without starting the game process.
  def new_game() do
    square = Block.square({4, 0})
    board = %Board{height: 20, width: 10, static_blocks: [], falling_block: square}

    %__MODULE__{board: board}
  end

  # Callbacks ######################################################

  @impl true
  def init(:ok) do
    {:ok, new_game()}
  end

  @impl true
  def handle_call(:start, {from_pid, _from_ref}, game) do
    if game.state == :new do
      :timer.send_interval(@tick, self(), :tick)
      {:reply, :ok, %{game | state: :running, subscriber: from_pid}}
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
  def handle_call(:advance, _from, game) do
    new_board = do_advance(game)
    send(self(), :inform_subscriber)
    {:reply, :ok, %{game | board: new_board}}
  end

  @impl true
  def handle_info(:tick, game) do
    new_board = do_advance(game)
    send(self(), :inform_subscriber)
    {:noreply, %{game | board: new_board}}
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
    if game.board.falling_block do
      Board.advance(game.board)
    else
      # TODO: implement a block queue
      %{game.board | falling_block: Block.square({4, 0})}
    end
  end
end
