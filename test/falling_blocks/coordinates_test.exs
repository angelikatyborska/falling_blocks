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

  describe "rotate_90deg_cw" do
    test "rotating relative to itself does nothing" do
      assert Coordinates.rotate_90deg_cw({0, 0}, {0, 0}) == {0, 0}
      assert Coordinates.rotate_90deg_cw({1, 1}, {1, 1}) == {1, 1}
      assert Coordinates.rotate_90deg_cw({100, 23}, {100, 23}) == {100, 23}
    end

    test "(-a, -a) -> (a, -a) -> (a, a) -> (-a, a)" do
      assert Coordinates.rotate_90deg_cw({1, 1}, {2, 2}) == {3, 1}
      assert Coordinates.rotate_90deg_cw({3, 1}, {2, 2}) == {3, 3}
      assert Coordinates.rotate_90deg_cw({3, 3}, {2, 2}) == {1, 3}
      assert Coordinates.rotate_90deg_cw({1, 3}, {2, 2}) == {1, 1}
    end

    test "(-a, -b) -> (b, -a) -> (a, b) -> (-b, a)" do
      assert Coordinates.rotate_90deg_cw({1, 1}, {3, 2}) == {4, 0}
      assert Coordinates.rotate_90deg_cw({4, 0}, {3, 2}) == {5, 3}
      assert Coordinates.rotate_90deg_cw({5, 3}, {3, 2}) == {2, 4}
      assert Coordinates.rotate_90deg_cw({2, 4}, {3, 2}) == {1, 1}
    end
  end
end
