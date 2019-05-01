defmodule FallingBlocks.Board do
  alias FallingBlocks.{Block, Coordinates}

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
    Useful for printing the board. `nil` means no block at those coordinates.
  """
  @spec block_type_at(__MODULE__.t(), Coordinates.t()) :: Block.block_type() | nil
  def block_type_at(board, {x, y}) do
    block =
      FallingBlocks.Board.find_static_block_at(board, {x, y}) ||
        (FallingBlocks.Board.falling_block_at?(board, {x, y}) && board.falling_block)

    if block do
      block.type
    else
      nil
    end
  end

  @spec find_static_block_at(__MODULE__.t(), Coordinates.t()) :: Block.t() | nil
  def find_static_block_at(board, {x, y}) do
    Enum.find(board.static_blocks, fn %{parts: parts} ->
      Enum.any?(parts, fn part -> part == {x, y} end)
    end)
  end

  @spec block_at?(Block.t() | nil, Coordinates.t()) :: boolean
  def block_at?(nil, _), do: false

  def block_at?(block, {x, y}) do
    Enum.any?(block.parts, fn part -> part == {x, y} end)
  end

  @spec falling_block_at?(__MODULE__.t(), Coordinates.t()) :: boolean
  def falling_block_at?(board, {x, y}) do
    block_at?(board.falling_block, {x, y})
  end

  @spec advance(__MODULE__.t()) :: __MODULE__.t()
  def advance(board) do
    with %Block{} <- board.falling_block,
         new_board <- %{board | falling_block: Block.advance(board.falling_block)},
         {:collisions, false} <- {:collisions, collisions?(new_board)} do
      new_board
    else
      nil ->
        board

      {:collisions, true} ->
        %{board | falling_block: nil, static_blocks: [board.falling_block | board.static_blocks]}
    end
  end

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

  defp collisions?(board) do
    with %Block{} <- board.falling_block do
      board.falling_block.parts
      |> Enum.any?(fn {x, y} = part ->
        find_static_block_at(board, part) ||
          y >= board.height ||
          x >= board.width ||
          x < 0
      end)
    else
      _ -> false
    end
  end
end

defimpl Inspect, for: FallingBlocks.Board do
  def inspect(%FallingBlocks.Board{} = board, _opts) do
    0..(board.height - 1)
    |> Enum.map(fn row ->
      0..(board.width - 1)
      |> Enum.map(fn column ->
        block_symbol(FallingBlocks.Board.block_type_at(board, {column, row}))
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp block_symbol(:square), do: "*"
  defp block_symbol(:long), do: "o"
  defp block_symbol(_), do: "."
end
