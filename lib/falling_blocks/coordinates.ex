defmodule FallingBlocks.Coordinates do
  @moduledoc """
  (0,0)
  +-----------> y (asc)
  |
  |    . (1, 1)
  |
  |
  x
  (asc)
  """
  @type t :: {integer(), integer()}

  @spec new(integer(), integer()) :: Coordinates.t()
  def new(x \\ 0, y \\ 0) do
    {x, y}
  end

  @spec right(Coordinates.t(), integer()) :: Coordinates.t()
  def right({x, y}, step \\ 1) do
    {x + step, y}
  end

  @spec left(Coordinates.t(), integer()) :: Coordinates.t()
  def left({x, y}, step \\ 1) do
    {x - step, y}
  end

  @spec up(Coordinates.t(), integer()) :: Coordinates.t()
  def up({x, y}, step \\ 1) do
    {x, y - step}
  end

  @spec down(Coordinates.t(), integer()) :: Coordinates.t()
  def down({x, y}, step \\ 1) do
    {x, y + step}
  end
end
