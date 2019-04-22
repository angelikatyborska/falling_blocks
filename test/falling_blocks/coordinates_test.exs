defmodule FallingBlocks.CoordinatesTest do
  use ExUnit.Case

  alias FallingBlocks.Coordinates

  test "right" do
    assert Coordinates.right(Coordinates.new(1, 2)) == {2, 2}
    assert Coordinates.right(Coordinates.new(1, 2), 4) == {5, 2}
    assert Coordinates.right(Coordinates.new(-1, 0)) == {0, 0}
  end

  test "left" do
    assert Coordinates.left(Coordinates.new(1, 2)) == {0, 2}
    assert Coordinates.left(Coordinates.new(1, 2), 4) == {-3, 2}
    assert Coordinates.left(Coordinates.new(-1, 0)) == {-2, 0}
  end

  test "up" do
    assert Coordinates.up(Coordinates.new(1, 2)) == {1, 1}
    assert Coordinates.up(Coordinates.new(1, 2), 4) == {1, -2}
    assert Coordinates.up(Coordinates.new(-1, 0)) == {-1, -1}
  end

  test "down" do
    assert Coordinates.down(Coordinates.new(1, 2)) == {1, 3}
    assert Coordinates.down(Coordinates.new(1, 2), 4) == {1, 6}
    assert Coordinates.down(Coordinates.new(-1, 0)) == {-1, 1}
  end
end
