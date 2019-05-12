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

  @spec level(integer()) :: integer()
  def level(current_lines) do
    level = trunc(current_lines / 10) + 1
    Enum.min([level, max_level()])
  end

  def max_level() do
    8
  end
end
