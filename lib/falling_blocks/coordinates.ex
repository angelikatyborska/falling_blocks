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

  @spec new(integer(), integer()) :: __MODULE__.t()
  def new(x \\ 0, y \\ 0) do
    {x, y}
  end

  @spec right(__MODULE__.t(), integer()) :: __MODULE__.t()
  def right({x, y}, step \\ 1) do
    {x + step, y}
  end

  @spec left(__MODULE__.t(), integer()) :: __MODULE__.t()
  def left({x, y}, step \\ 1) do
    {x - step, y}
  end

  @spec up(__MODULE__.t(), integer()) :: __MODULE__.t()
  def up({x, y}, step \\ 1) do
    {x, y - step}
  end

  @spec down(__MODULE__.t(), integer()) :: __MODULE__.t()
  def down({x, y}, step \\ 1) do
    {x, y + step}
  end
end
