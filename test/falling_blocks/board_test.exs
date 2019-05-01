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

  describe "advance" do
    test "it does nothing if no falling block" do
      square1 = Block.square({0, 4})
      square2 = Block.square({1, 2})

      board = %Board{height: 6, width: 3, static_blocks: [square1, square2], falling_block: nil}

      assert Board.advance(board) == board
    end

    test "it advances the falling block" do
      square = Block.square({0, 0})
      board = %Board{height: 6, width: 3, static_blocks: [], falling_block: square}

      board2 = Board.advance(board)
      board3 = Board.advance(board2)

      assert inspect(board) == ~s"""
             * * .
             * * .
             . . .
             . . .
             . . .
             . . .
             """

      assert inspect(board2) == ~s"""
             . . .
             * * .
             * * .
             . . .
             . . .
             . . .
             """

      assert inspect(board3) == ~s"""
             . . .
             . . .
             * * .
             * * .
             . . .
             . . .
             """
    end

    test "it stops the block when other block blocks it" do
      square = Block.square({0, 2})
      long = Block.long({0, 5})
      board = %Board{height: 6, width: 4, static_blocks: [long], falling_block: square}

      board2 = Board.advance(board)
      board3 = Board.advance(board2)

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             * * . .
             * * . .
             . . . .
             o o o o
             """

      assert inspect(board2) == ~s"""
             . . . .
             . . . .
             . . . .
             * * . .
             * * . .
             o o o o
             """

      assert inspect(board3) == ~s"""
             . . . .
             . . . .
             . . . .
             * * . .
             * * . .
             o o o o
             """
    end

    test "it stops the block when end of board" do
      square = Block.square({0, 3})
      board = %Board{height: 6, width: 4, static_blocks: [], falling_block: square}

      board2 = Board.advance(board)
      board3 = Board.advance(board2)

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             . . . .
             * * . .
             * * . .
             . . . .
             """

      assert inspect(board2) == ~s"""
             . . . .
             . . . .
             . . . .
             . . . .
             * * . .
             * * . .
             """

      assert inspect(board3) == ~s"""
             . . . .
             . . . .
             . . . .
             . . . .
             * * . .
             * * . .
             """

      assert board3.falling_block == nil
    end
  end

  describe "move" do
    test "it does nothing if no falling block" do
      square1 = Block.square({0, 4})
      square2 = Block.square({1, 2})

      board = %Board{height: 6, width: 3, static_blocks: [square1, square2], falling_block: nil}

      assert Board.move(board, :right) == board
    end

    test "it moves the falling block to the left" do
      square = Block.square({2, 0})
      board = %Board{height: 3, width: 6, static_blocks: [], falling_block: square}

      board2 = Board.move(board, :left)
      board3 = Board.move(board2, :left)

      assert inspect(board) == ~s"""
             . . * * . .
             . . * * . .
             . . . . . .
             """

      assert inspect(board2) == ~s"""
             . * * . . .
             . * * . . .
             . . . . . .
             """

      assert inspect(board3) == ~s"""
             * * . . . .
             * * . . . .
             . . . . . .
             """
    end

    test "it moves the falling block to the right" do
      square = Block.square({2, 0})
      board = %Board{height: 3, width: 6, static_blocks: [], falling_block: square}

      board2 = Board.move(board, :right)
      board3 = Board.move(board2, :right)

      assert inspect(board) == ~s"""
             . . * * . .
             . . * * . .
             . . . . . .
             """

      assert inspect(board2) == ~s"""
             . . . * * .
             . . . * * .
             . . . . . .
             """

      assert inspect(board3) == ~s"""
             . . . . * *
             . . . . * *
             . . . . . .
             """
    end

    test "it stops on board edges" do
      square = Block.square({0, 0})
      board = %Board{height: 3, width: 2, static_blocks: [], falling_block: square}

      board2 = Board.move(board, :right)
      board3 = Board.move(board2, :right)
      board4 = Board.move(board3, :left)
      board5 = Board.move(board4, :left)

      result = ~s"""
      * *
      * *
      . .
      """

      assert inspect(board) == result
      assert inspect(board2) == result
      assert inspect(board3) == result
      assert inspect(board4) == result
      assert inspect(board5) == result
    end

    test "it stops on block edges" do
      square = Block.square({2, 0})
      square2 = Block.square({0, 1})
      square3 = Block.square({4, 1})

      board = %Board{
        height: 3,
        width: 6,
        static_blocks: [square2, square3],
        falling_block: square
      }

      board2 = Board.move(board, :right)
      board3 = Board.move(board2, :right)
      board4 = Board.move(board3, :left)
      board5 = Board.move(board4, :left)

      result = ~s"""
      . . * * . .
      * * * * * *
      * * . . * *
      """

      assert inspect(board) == result
      assert inspect(board2) == result
      assert inspect(board3) == result
      assert inspect(board4) == result
      assert inspect(board5) == result
    end
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
