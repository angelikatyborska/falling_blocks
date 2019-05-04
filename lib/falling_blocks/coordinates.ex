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

  @doc """
    Rotates the coordinates 90deg clockwise relative to a given rotation point

        (0,0)
    +---------A'> y (asc)
    |  A
    |      RP
    |
    |
    x
    (asc)

    For example, if A = (1, 1) and RP = (3, 1)
    then rotate(A, RP) = (4, 0) = A'

    More general:
    (-a, -b) -> (b, -a) -> (a, b) -> (-b, a)

    where a, b are absolute values of x, y or y, x coordinates of the point relative to the rotation point
  """
  @spec rotate_90deg_cw(__MODULE__.t(), __MODULE__.t()) :: __MODULE__.t()
  def rotate_90deg_cw({x, y}, rotation_point) do
    {rpx, rpy} = rotation_point

    dx = x - rpx
    dy = y - rpy

    {d2x_sign, d2y_sign} =
      cond do
        dx < 0 && dy < 0 -> {1, -1}
        dx >= 0 && dy < 0 -> {1, 1}
        dx >= 0 && dy >= 0 -> {-1, 1}
        dx < 0 && dy >= 0 -> {-1, -1}
      end

    d2x = abs(dy)
    d2y = abs(dx)

    result = {trunc(rpx + d2x * d2x_sign), trunc(rpy + d2y * d2y_sign)}

    result
  end
end
