defmodule FallingBlocks.Board do
  alias FallingBlocks.Block

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

  @spec find_static_block_at(__MODULE__.t(), Coordinates.t()) :: Block.t() | nil
  def find_static_block_at(board, {x, y}) do
    Enum.find(board.static_blocks, fn %{parts: parts} ->
      Enum.any?(parts, fn part -> part == {x, y} end)
    end)
  end
end

defimpl Inspect, for: FallingBlocks.Board do
  def inspect(%FallingBlocks.Board{} = board, _opts) do
    0..(board.height - 1)
    |> Enum.map(fn row ->
      0..(board.width - 1)
      |> Enum.map(fn column ->
        case FallingBlocks.Board.find_static_block_at(board, {column, row}) do
          nil -> "."
          %{type: :square} -> "*"
          %{type: :long} -> "o"
        end
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
end
