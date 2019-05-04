defmodule FallingBlocks.BoardTest do
  use ExUnit.Case

  alias FallingBlocks.Board
  alias FallingBlocks.Block

  describe "set_falling_block" do
    test "game over if there is a conflict, puts as much of block as possible" do
      o = Block.o({1, 1})
      board = %Board{height: 3, width: 6, static_blocks: [o]}

      {:game_over, board2} = Board.set_falling_block(board, :o)

      assert inspect(board) == ~s"""
             . . . . . .
             . o o . . .
             . o o . . .
             """

      assert inspect(board2) == ~s"""
             . . o o . .
             . o o . . .
             . o o . . .
             """
    end

    test "it puts o in the middle" do
      odd_board = %Board{height: 3, width: 5}
      even_board = %Board{height: 3, width: 6}

      {:ok, new_odd_board} = Board.set_falling_block(odd_board, :o)
      {:ok, new_even_board} = Board.set_falling_block(even_board, :o)

      assert inspect(new_odd_board) == ~s"""
             . o o . .
             . o o . .
             . . . . .
             """

      assert inspect(new_even_board) == ~s"""
             . . o o . .
             . . o o . .
             . . . . . .
             """
    end

    test "it puts i in the middle" do
      odd_board = %Board{height: 3, width: 5}
      even_board = %Board{height: 3, width: 6}

      {:ok, new_odd_board} = Board.set_falling_block(odd_board, :i)
      {:ok, new_even_board} = Board.set_falling_block(even_board, :i)

      assert inspect(new_odd_board) == ~s"""
             i i i i .
             . . . . .
             . . . . .
             """

      assert inspect(new_even_board) == ~s"""
             . i i i i .
             . . . . . .
             . . . . . .
             """
    end

    # TODO: add more tests for new types of blocks and rotated blocks
  end

  test "static_block_at" do
    o1 = Block.o({0, 4})
    o2 = Block.o({1, 2})

    board = %Board{height: 6, width: 3, static_blocks: [o1, o2]}

    assert Board.static_block_at(board, {0, 4}) == o1
    assert Board.static_block_at(board, {1, 4}) == o1
    assert Board.static_block_at(board, {0, 5}) == o1
    assert Board.static_block_at(board, {1, 5}) == o1

    assert Board.static_block_at(board, {1, 2}) == o2
    assert Board.static_block_at(board, {2, 2}) == o2
    assert Board.static_block_at(board, {1, 3}) == o2
    assert Board.static_block_at(board, {2, 3}) == o2

    assert Board.static_block_at(board, {0, 0}) == nil
    assert Board.static_block_at(board, {1, 1}) == nil
  end

  describe "advance" do
    test "it does nothing if no falling block" do
      o1 = Block.o({0, 4})
      o2 = Block.o({1, 2})

      board = %Board{height: 6, width: 3, static_blocks: [o1, o2], falling_block: nil}
      {board2, _} = Board.advance(board)
      assert board2 == board
    end

    test "it advances the falling block" do
      i = Block.i({0, 0})
      board = %Board{height: 5, width: 4, static_blocks: [], falling_block: i}

      {board2, _} = Board.advance(board)
      {board3, _} = Board.advance(board2)

      assert inspect(board) == ~s"""
             i i i i
             . . . .
             . . . .
             . . . .
             . . . .
             """

      assert inspect(board2) == ~s"""
             . . . .
             i i i i
             . . . .
             . . . .
             . . . .
             """

      assert inspect(board3) == ~s"""
             . . . .
             . . . .
             i i i i
             . . . .
             . . . .
             """
    end

    test "it stops the block when other block blocks it" do
      o = Block.o({0, 2})
      i = Block.i({0, 5})
      board = %Board{height: 6, width: 4, static_blocks: [i], falling_block: o}

      {board2, _} = Board.advance(board)
      {board3, _} = Board.advance(board2)

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             o o . .
             o o . .
             . . . .
             i i i i
             """

      assert inspect(board2) == ~s"""
             . . . .
             . . . .
             . . . .
             o o . .
             o o . .
             i i i i
             """

      assert inspect(board3) == ~s"""
             . . . .
             . . . .
             . . . .
             o o . .
             o o . .
             i i i i
             """
    end

    test "it stops the block when end of board" do
      o = Block.o({0, 3})
      board = %Board{height: 6, width: 4, static_blocks: [], falling_block: o}

      {board2, _} = Board.advance(board)
      {board3, _} = Board.advance(board2)

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             . . . .
             o o . .
             o o . .
             . . . .
             """

      assert inspect(board2) == ~s"""
             . . . .
             . . . .
             . . . .
             . . . .
             o o . .
             o o . .
             """

      assert inspect(board3) == ~s"""
             . . . .
             . . . .
             . . . .
             . . . .
             o o . .
             o o . .
             """

      assert board3.falling_block == nil
    end

    test "it clears full rows" do
      i = Block.i({0, 3})
      i2 = Block.i({0, 2})
      i3 = Block.i({0, 1})
      o = Block.o({4, 2})

      board = %Board{
        width: 6,
        height: 4,
        static_blocks: [i, i2, i3],
        falling_block: o
      }

      {board2, rows_cleared} = Board.advance(board)

      assert rows_cleared == 2

      assert inspect(board) == ~s"""
             . . . . . .
             i i i i . .
             i i i i o o
             i i i i o o
             """

      assert inspect(board2) == ~s"""
             . . . . . .
             . . . . . .
             . . . . . .
             i i i i . .
             """
    end
  end

  describe "move" do
    test "it does nothing if no falling block" do
      o1 = Block.o({0, 4})
      o2 = Block.o({1, 2})

      board = %Board{height: 6, width: 3, static_blocks: [o1, o2], falling_block: nil}

      assert Board.move(board, :right) == board
    end

    test "it moves the falling block to the left" do
      o = Block.o({2, 0})
      board = %Board{height: 3, width: 6, static_blocks: [], falling_block: o}

      board2 = Board.move(board, :left)
      board3 = Board.move(board2, :left)

      assert inspect(board) == ~s"""
             . . o o . .
             . . o o . .
             . . . . . .
             """

      assert inspect(board2) == ~s"""
             . o o . . .
             . o o . . .
             . . . . . .
             """

      assert inspect(board3) == ~s"""
             o o . . . .
             o o . . . .
             . . . . . .
             """
    end

    test "it moves the falling block to the right" do
      o = Block.o({2, 0})
      board = %Board{height: 3, width: 6, static_blocks: [], falling_block: o}

      board2 = Board.move(board, :right)
      board3 = Board.move(board2, :right)

      assert inspect(board) == ~s"""
             . . o o . .
             . . o o . .
             . . . . . .
             """

      assert inspect(board2) == ~s"""
             . . . o o .
             . . . o o .
             . . . . . .
             """

      assert inspect(board3) == ~s"""
             . . . . o o
             . . . . o o
             . . . . . .
             """
    end

    test "it stops on board edges" do
      o = Block.o({0, 0})
      board = %Board{height: 3, width: 2, static_blocks: [], falling_block: o}

      board2 = Board.move(board, :right)
      board3 = Board.move(board2, :right)
      board4 = Board.move(board3, :left)
      board5 = Board.move(board4, :left)

      result = ~s"""
      o o
      o o
      . .
      """

      assert inspect(board) == result
      assert inspect(board2) == result
      assert inspect(board3) == result
      assert inspect(board4) == result
      assert inspect(board5) == result
    end

    test "it stops on block edges" do
      o = Block.o({2, 0})
      o2 = Block.o({0, 1})
      o3 = Block.o({4, 1})

      board = %Board{
        height: 3,
        width: 6,
        static_blocks: [o2, o3],
        falling_block: o
      }

      board2 = Board.move(board, :right)
      board3 = Board.move(board2, :right)
      board4 = Board.move(board3, :left)
      board5 = Board.move(board4, :left)

      result = ~s"""
      . . o o . .
      o o o o o o
      o o . . o o
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

    test "two static os" do
      os = [
        Block.o({0, 4}),
        Block.o({1, 2})
      ]

      board = %Board{height: 6, width: 3, static_blocks: os}

      assert inspect(board) == ~s"""
             . . .
             . . .
             . o o
             . o o
             o o .
             o o .
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
             i i i i
             . o o .
             . o o .
             i i i i
             """
    end

    test "a falling i" do
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
