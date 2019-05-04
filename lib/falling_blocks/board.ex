defmodule FallingBlocks.Board do
  alias FallingBlocks.{Block, Coordinates}
  alias FallingBlocks.Board.Row

  @standard_width 10
  @standard_height 20

  defstruct falling_block: nil,
            static_blocks: [],
            height: @standard_height,
            width: @standard_width

  @type t :: %__MODULE__{
          falling_block: Block.t(),
          static_blocks: list(Block.t()),
          height: number(),
          width: number()
        }

  @type direction :: :left | :right

  @doc """
    Sets the current falling block if there is none.
  """
  @spec set_falling_block(%__MODULE__{falling_block: nil}, Block.block_type()) ::
          {:ok | :game_over, __MODULE__.t()}
  def set_falling_block(board, block_type) do
    if board.falling_block do
      raise "Cannot set falling block, it already exists"
    else
      left = trunc((board.width - Block.width(block_type)) / 2)
      falling_block = apply(Block, block_type, [{left, 0}])
      board = %{board | falling_block: falling_block}

      if collisions?(board) do
        {:game_over, find_first_possible_overflowing_placement(board)}
      else
        {:ok, board}
      end
    end
  end

  @doc """
    Returns the block type at given coordinates. `nil` means no block there.
    Useful for printing the board.
  """
  @spec block_type_at(__MODULE__.t(), Coordinates.t()) :: Block.block_type() | nil
  def block_type_at(board, {x, y}) do
    block =
      FallingBlocks.Board.static_block_at(board, {x, y}) ||
        (FallingBlocks.Board.falling_block_at?(board, {x, y}) && board.falling_block)

    if block do
      block.type
    else
      nil
    end
  end

  @doc """
    Returns a static blocks at given coordinates. `nil` means no static block there.
    A static block is a block that has already landed.
  """
  @spec static_block_at(__MODULE__.t(), Coordinates.t()) :: Block.t() | nil
  def static_block_at(board, {x, y}) do
    Enum.find(board.static_blocks, fn %{parts: parts} ->
      Enum.any?(parts, fn part -> part == {x, y} end)
    end)
  end

  @doc """
    Checks if the falling block is currently at the given coordinates.
  """
  @spec falling_block_at?(__MODULE__.t(), Coordinates.t()) :: boolean
  def falling_block_at?(board, {x, y}) do
    block_at?(board.falling_block, {x, y})
  end

  @doc """
    Advances the current falling block one step down.
    If the falling block has landed, moves it to static blocks and clears the current falling block.
    If there is no falling block, does nothing.
    Returns the new board and the number of cleared rows.
  """
  @spec advance(__MODULE__.t()) :: {__MODULE__.t(), integer()}
  def advance(board) do
    with %Block{} <- board.falling_block,
         new_board <- %{board | falling_block: Block.advance(board.falling_block)},
         {:collisions, false} <- {:collisions, collisions?(new_board)} do
      {new_board, 0}
    else
      nil ->
        {board, 0}

      {:collisions, true} ->
        new_board = %{
          board
          | falling_block: nil,
            static_blocks: [board.falling_block | board.static_blocks]
        }

        remove_rows_that_could_have_been_filled(new_board, board.falling_block)
    end
  end

  @doc """
    Moves the current falling block to the left or to the right.
    Does nothing if a move is blocked by static blocks or the board.
    Does nothing if there is no falling block.
  """
  @spec move(__MODULE__.t(), __MODULE__.direction()) :: __MODULE__.t()
  def move(board, direction) do
    with %Block{} <- board.falling_block,
         new_board <- %{board | falling_block: apply(Block, direction, [board.falling_block])},
         {:collisions, false} <- {:collisions, collisions?(new_board)} do
      new_board
    else
      nil ->
        board

      {:collisions, true} ->
        board
    end
  end

  defp block_at?(nil, _), do: false

  defp block_at?(block, {x, y}) do
    Enum.any?(block.parts, fn part -> part == {x, y} end)
  end

  defp collisions?(board) do
    with %Block{} <- board.falling_block do
      board.falling_block.parts
      |> Enum.any?(fn {x, y} = part ->
        static_block_at(board, part) ||
          y >= board.height ||
          x >= board.width ||
          x < 0
      end)
    else
      _ -> false
    end
  end

  defp find_first_possible_overflowing_placement(board) do
    falling_block = Block.up(board.falling_block)
    board = %{board | falling_block: falling_block}

    if collisions?(board) do
      find_first_possible_overflowing_placement(board)
    else
      board
    end
  end

  defp remove_rows_that_could_have_been_filled(board, old_falling_block) do
    old_falling_block
    |> Block.rows()
    |> Enum.reduce({board, 0}, fn row, {acc_board, acc_lines} = acc ->
      if Row.full?(acc_board, row) do
        {Row.remove(acc_board, row), acc_lines + 1}
      else
        acc
      end
    end)
  end
end
