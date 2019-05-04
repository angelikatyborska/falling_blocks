defmodule FallingBlocks.BlockTest do
  use ExUnit.Case

  alias FallingBlocks.Block

  describe "advance" do
    test "it moves a block down" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.advance(o)

      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {1, 4}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 4}))
    end
  end

  describe "left" do
    test "it moves a block left" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.left(o)

      assert o.parts |> Enum.find(&(&1 == {0, 2}))
      assert o.parts |> Enum.find(&(&1 == {0, 3}))
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
    end
  end

  describe "right" do
    test "it moves a block right" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.right(o)

      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))
      assert o.parts |> Enum.find(&(&1 == {3, 2}))
      assert o.parts |> Enum.find(&(&1 == {3, 3}))
    end
  end

  describe "up" do
    test "it moves a block up" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.up(o)

      assert o.parts |> Enum.find(&(&1 == {1, 1}))
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 1}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
    end
  end

  describe "o" do
    test "it puts an o" do
      o = Block.o({1, 2})
      assert o.type == :o
      assert o.parts |> Enum.count() == 4
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))
    end
  end

  describe "i" do
    test "it puts the block horizontally" do
      i = Block.i({2, 1})
      assert i.type == :i
      assert i.parts |> Enum.count() == 4
      assert i.parts |> Enum.find(&(&1 == {2, 1}))
      assert i.parts |> Enum.find(&(&1 == {3, 1}))
      assert i.parts |> Enum.find(&(&1 == {4, 1}))
      assert i.parts |> Enum.find(&(&1 == {5, 1}))
    end
  end

  describe "t" do
    test "it puts the block vertically" do
      t = Block.t({2, 1})
      assert t.type == :t
      assert t.parts |> Enum.count() == 4
      assert t.parts |> Enum.find(&(&1 == {3, 1}))
      assert t.parts |> Enum.find(&(&1 == {2, 2}))
      assert t.parts |> Enum.find(&(&1 == {3, 2}))
      assert t.parts |> Enum.find(&(&1 == {4, 2}))
    end
  end

  describe "width" do
    test "it counts the width" do
      assert Block.width(:i) == 4
      assert Block.width(:o) == 2
    end
  end

  describe "remove_row" do
    test "returns nil if block would no longer have any parts" do
      i = Block.i({2, 1})
      assert Block.remove_row(i, 1) == nil
    end

    test "removes parts of the block that lie on the given row and moves down the ones above it" do
      o = Block.o({1, 2})
      o2 = Block.remove_row(o, 3)
      assert o2.parts |> Enum.count() == 2
      assert o2.parts |> Enum.find(&(&1 == {1, 3}))
      assert o2.parts |> Enum.find(&(&1 == {2, 3}))
    end
  end

  describe "rows" do
    test "it returns a list of all rows occupied by this block" do
      i = Block.i({2, 1})
      o = Block.o({1, 2})

      assert Block.rows(i) == [1]
      assert Block.rows(o) == [2, 3]
    end
  end
end
