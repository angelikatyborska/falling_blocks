defmodule FallingBlocks.Board.InspectTest do
  use ExUnit.Case

  alias FallingBlocks.Board
  alias FallingBlocks.Block

  describe "inspect" do
    test "empty board" do
      empty = %Board{height: 6, width: 3}

      assert inspect(empty) == ~s"""
             . . .
             . . .
             . . .
             . . .
             . . .
             . . .
             """
    end

    test "a T" do
      block = Block.t({0, 1})
      board = %Board{height: 3, width: 3, static_blocks: [block]}

      assert inspect(board) == ~s"""
             . . .
             . t .
             t t t
             """
    end

    test "a J" do
      block = Block.j({0, 0})
      board = %Board{height: 3, width: 3, static_blocks: [block]}

      assert inspect(board) == ~s"""
             . j .
             . j .
             j j .
             """
    end

    test "an L" do
      block = Block.l({0, 0})
      board = %Board{height: 3, width: 3, static_blocks: [block]}

      assert inspect(board) == ~s"""
             l . .
             l . .
             l l .
             """
    end

    test "a Z" do
      block = Block.z({0, 1})
      board = %Board{height: 3, width: 3, static_blocks: [block]}

      assert inspect(board) == ~s"""
             . . .
             z z .
             . z z
             """
    end

    test "an S" do
      block = Block.s({0, 1})
      board = %Board{height: 3, width: 3, static_blocks: [block]}

      assert inspect(board) == ~s"""
             . . .
             . s s
             s s .
             """
    end

    test "two static Os" do
      blocks = [
        Block.o({0, 4}),
        Block.o({1, 2})
      ]

      board = %Board{height: 6, width: 3, static_blocks: blocks}

      assert inspect(board) == ~s"""
             . . .
             . . .
             . o o
             . o o
             o o .
             o o .
             """
    end

    test "an O and two Is" do
      blocks = [
        Block.i({0, 4}),
        Block.o({1, 5}),
        Block.i({0, 7})
      ]

      board = %Board{height: 8, width: 4, static_blocks: blocks}

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             . . . .
             . . . .
             i i i i
             . o o .
             . o o .
             i i i i
             """
    end

    test "a falling I" do
      i = Block.i({0, 2})
      board = %Board{height: 8, width: 4, static_blocks: [], falling_block: i}

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             i i i i
             . . . .
             . . . .
             . . . .
             . . . .
             . . . .
             """
    end
  end
end
