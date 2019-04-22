defmodule FallingBlocks.BoardTest do
  use ExUnit.Case

  alias FallingBlocks.Board
  alias FallingBlocks.Block

  test "find_static_block_at" do
    square1 = Block.square({0, 4})
    square2 = Block.square({1, 2})

    board = %Board{height: 6, width: 3, static_blocks: [square1, square2]}

    assert Board.find_static_block_at(board, {0, 4}) == square1
    assert Board.find_static_block_at(board, {1, 4}) == square1
    assert Board.find_static_block_at(board, {0, 5}) == square1
    assert Board.find_static_block_at(board, {1, 5}) == square1

    assert Board.find_static_block_at(board, {1, 2}) == square2
    assert Board.find_static_block_at(board, {2, 2}) == square2
    assert Board.find_static_block_at(board, {1, 3}) == square2
    assert Board.find_static_block_at(board, {2, 3}) == square2

    assert Board.find_static_block_at(board, {0, 0}) == nil
    assert Board.find_static_block_at(board, {1, 1}) == nil
  end

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
  end
end
