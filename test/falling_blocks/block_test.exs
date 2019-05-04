defmodule FallingBlocks.BlockTest do
  use ExUnit.Case

  alias FallingBlocks.Block

  describe "advance" do
    test "it moves a block down" do
      square = Block.square({1, 2})
      assert square.parts |> Enum.find(&(&1 == {1, 2}))
      assert square.parts |> Enum.find(&(&1 == {1, 3}))
      assert square.parts |> Enum.find(&(&1 == {2, 2}))
      assert square.parts |> Enum.find(&(&1 == {2, 3}))

      square = Block.advance(square)

      assert square.parts |> Enum.find(&(&1 == {1, 3}))
      assert square.parts |> Enum.find(&(&1 == {1, 4}))
      assert square.parts |> Enum.find(&(&1 == {2, 3}))
      assert square.parts |> Enum.find(&(&1 == {2, 4}))
    end
  end

  describe "left" do
    test "it moves a block left" do
      square = Block.square({1, 2})
      assert square.parts |> Enum.find(&(&1 == {1, 2}))
      assert square.parts |> Enum.find(&(&1 == {1, 3}))
      assert square.parts |> Enum.find(&(&1 == {2, 2}))
      assert square.parts |> Enum.find(&(&1 == {2, 3}))

      square = Block.left(square)

      assert square.parts |> Enum.find(&(&1 == {0, 2}))
      assert square.parts |> Enum.find(&(&1 == {0, 3}))
      assert square.parts |> Enum.find(&(&1 == {1, 2}))
      assert square.parts |> Enum.find(&(&1 == {1, 3}))
    end
  end

  describe "right" do
    test "it moves a block right" do
      square = Block.square({1, 2})
      assert square.parts |> Enum.find(&(&1 == {1, 2}))
      assert square.parts |> Enum.find(&(&1 == {1, 3}))
      assert square.parts |> Enum.find(&(&1 == {2, 2}))
      assert square.parts |> Enum.find(&(&1 == {2, 3}))

      square = Block.right(square)

      assert square.parts |> Enum.find(&(&1 == {2, 2}))
      assert square.parts |> Enum.find(&(&1 == {2, 3}))
      assert square.parts |> Enum.find(&(&1 == {3, 2}))
      assert square.parts |> Enum.find(&(&1 == {3, 3}))
    end
  end

  describe "up" do
    test "it moves a block up" do
      square = Block.square({1, 2})
      assert square.parts |> Enum.find(&(&1 == {1, 2}))
      assert square.parts |> Enum.find(&(&1 == {1, 3}))
      assert square.parts |> Enum.find(&(&1 == {2, 2}))
      assert square.parts |> Enum.find(&(&1 == {2, 3}))

      square = Block.up(square)

      assert square.parts |> Enum.find(&(&1 == {1, 1}))
      assert square.parts |> Enum.find(&(&1 == {1, 2}))
      assert square.parts |> Enum.find(&(&1 == {2, 1}))
      assert square.parts |> Enum.find(&(&1 == {2, 2}))
    end
  end

  describe "square" do
    test "it puts a square" do
      square = Block.square({1, 2})
      assert square.type == :square
      assert square.parts |> Enum.count() == 4
      assert square.parts |> Enum.find(&(&1 == {1, 2}))
      assert square.parts |> Enum.find(&(&1 == {1, 3}))
      assert square.parts |> Enum.find(&(&1 == {2, 2}))
      assert square.parts |> Enum.find(&(&1 == {2, 3}))
    end
  end

  describe "long" do
    test "it puts the block horizontally" do
      long = Block.long({2, 1})
      assert long.type == :long
      assert long.parts |> Enum.count() == 4
      assert long.parts |> Enum.find(&(&1 == {2, 1}))
      assert long.parts |> Enum.find(&(&1 == {3, 1}))
      assert long.parts |> Enum.find(&(&1 == {4, 1}))
      assert long.parts |> Enum.find(&(&1 == {5, 1}))
    end
  end

  describe "width" do
    test "it counts the width" do
      assert Block.width(:long) == 4
      assert Block.width(:square) == 2
    end
  end

  describe "remove_row" do
    test "returns nil if block would no longer have any parts" do
      long = Block.long({2, 1})
      assert Block.remove_row(long, 1) == nil
    end

    test "removes parts of the block that lie on the given row and moves down the ones above it" do
      square = Block.square({1, 2})
      square2 = Block.remove_row(square, 3)
      assert square2.parts |> Enum.count() == 2
      assert square2.parts |> Enum.find(&(&1 == {1, 3}))
      assert square2.parts |> Enum.find(&(&1 == {2, 3}))
    end
  end

  describe "rows" do
    test "it returns a list of all rows occupied by this block" do
      long = Block.long({2, 1})
      square = Block.square({1, 2})

      assert Block.rows(long) == [1]
      assert Block.rows(square) == [2, 3]
    end
  end
end
