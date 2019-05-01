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
end
