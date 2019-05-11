defmodule FallingBlocks.Score do
  @spec lines_cleared(integer(), integer()) :: integer()
  def lines_cleared(level, lines_cleared) do
    base =
      case lines_cleared do
        0 -> 0
        1 -> 40
        2 -> 100
        3 -> 300
        4 -> 1200
      end

    base * level
  end
end
