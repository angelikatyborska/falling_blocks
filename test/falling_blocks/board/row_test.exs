defmodule FallingBlocks.Board.RowTest do
  use ExUnit.Case

  alias FallingBlocks.{Board, Block}
  alias FallingBlocks.Board.Row

  describe "full?" do
    test "it checks if given row is full with static blocks" do
      long = Block.long({0, 3})
      square = Block.square({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [long, square]}

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . * *
             o o o o * *
             """

      assert Row.full?(board, 0) == false
      assert Row.full?(board, 1) == false
      assert Row.full?(board, 2) == false
      assert Row.full?(board, 3) == true
    end

    test "it ignores the falling block" do
      long = Block.long({0, 3})
      square = Block.square({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [long], falling_block: square}

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . * *
             o o o o * *
             """

      assert Row.full?(board, 0) == false
      assert Row.full?(board, 1) == false
      assert Row.full?(board, 2) == false
      assert Row.full?(board, 3) == false
    end

    test "it doesn't have to be the lowest row" do
      square_bottom_left = Block.square({0, 2})
      square_bottom_right = Block.square({4, 2})
      square_top_right = Block.square({4, 0})
      long = Block.long({0, 1})

      board = %Board{
        width: 6,
        height: 4,
        static_blocks: [square_bottom_left, square_bottom_right, square_top_right, long]
      }

      assert inspect(board) == ~s"""
             . . . . * *
             o o o o * *
             * * . . * *
             * * . . * *
             """

      assert Row.full?(board, 0) == false
      assert Row.full?(board, 1) == true
      assert Row.full?(board, 2) == false
      assert Row.full?(board, 3) == false
    end
  end

  describe "remove" do
    test "it removes the row and moves the ones above down" do
      long = Block.long({0, 3})
      square = Block.square({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [long, square]}
      board2 = Row.remove(board, 3)

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . * *
             o o o o * *
             """

      assert inspect(board2) == ~s"""
             . . . . . .
             . . . . . .
             . . . . . .
             . . . . * *
             """
    end

    test "it removes blocks that have no more parts" do
      long = Block.long({0, 3})
      square = Block.square({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [long, square]}
      board2 = Row.remove(board, 3)

      assert board2.static_blocks |> Enum.count() == 1
      assert (board2.static_blocks |> Enum.at(0)).type == :square
    end

    test "does nothing if the row is empty" do
      long = Block.long({0, 3})
      square = Block.square({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [long, square]}
      board2 = Row.remove(board, 1)

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . * *
             o o o o * *
             """

      assert inspect(board2) == ~s"""
             . . . . . .
             . . . . . .
             . . . . * *
             o o o o * *
             """
    end

    test "it doesn't have to be the lowest row" do
      square_bottom_left = Block.square({0, 2})
      square_bottom_right = Block.square({4, 2})
      square_top_right = Block.square({4, 0})
      long = Block.long({0, 1})

      board = %Board{
        width: 6,
        height: 4,
        static_blocks: [square_bottom_left, square_bottom_right, square_top_right, long]
      }

      board2 = Row.remove(board, 2)

      assert inspect(board) == ~s"""
             . . . . * *
             o o o o * *
             * * . . * *
             * * . . * *
             """

      assert inspect(board2) == ~s"""
             . . . . . .
             . . . . * *
             o o o o * *
             * * . . * *
             """
    end
  end
end
