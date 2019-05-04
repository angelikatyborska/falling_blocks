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

    test "two static os" do
      os = [
        Block.o({0, 4}),
        Block.o({1, 2})
      ]

      board = %Board{height: 6, width: 3, static_blocks: os}

      assert inspect(board) == ~s"""
             . . .
             . . .
             . * *
             . * *
             * * .
             * * .
             """
    end

    test "a o and two is" do
      os = [
        Block.i({0, 4}),
        Block.o({1, 5}),
        Block.i({0, 7})
      ]

      board = %Board{height: 8, width: 4, static_blocks: os}

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             . . . .
             . . . .
             o o o o
             . * * .
             . * * .
             o o o o
             """
    end

    test "a falling i" do
      i = Block.i({0, 2})
      board = %Board{height: 8, width: 4, static_blocks: [], falling_block: i}

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             o o o o
             . . . .
             . . . .
             . . . .
             . . . .
             . . . .
             """
    end
  end
end
