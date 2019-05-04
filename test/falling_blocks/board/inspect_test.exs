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

    test "two static squares" do
      squares = [
        Block.square({0, 4}),
        Block.square({1, 2})
      ]

      board = %Board{height: 6, width: 3, static_blocks: squares}

      assert inspect(board) == ~s"""
             . . .
             . . .
             . * *
             . * *
             * * .
             * * .
             """
    end

    test "a square and two longs" do
      squares = [
        Block.long({0, 4}),
        Block.square({1, 5}),
        Block.long({0, 7})
      ]

      board = %Board{height: 8, width: 4, static_blocks: squares}

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

    test "a falling long" do
      long = Block.long({0, 2})
      board = %Board{height: 8, width: 4, static_blocks: [], falling_block: long}

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
