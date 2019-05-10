defmodule FallingBlocks.Board.RowTest do
  use ExUnit.Case

  alias FallingBlocks.{Board, Block}
  alias FallingBlocks.Board.Row

  describe "full?" do
    test "it checks if given row is full with static blocks" do
      i = Block.i({0, 3})
      o = Block.o({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [i, o]}

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . o o
             i i i i o o
             """

      assert Row.full?(board, 0) == false
      assert Row.full?(board, 1) == false
      assert Row.full?(board, 2) == false
      assert Row.full?(board, 3) == true
    end

    test "it ignores the falling block" do
      i = Block.i({0, 3})
      o = Block.o({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [i], falling_block: o}

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . o o
             i i i i o o
             """

      assert Row.full?(board, 0) == false
      assert Row.full?(board, 1) == false
      assert Row.full?(board, 2) == false
      assert Row.full?(board, 3) == false
    end

    test "it doesn't have to be the lowest row" do
      o_bottom_left = Block.o({0, 2})
      o_bottom_right = Block.o({4, 2})
      o_top_right = Block.o({4, 0})
      i = Block.i({0, 1})

      board = %Board{
        width: 6,
        height: 4,
        static_blocks: [o_bottom_left, o_bottom_right, o_top_right, i]
      }

      assert inspect(board) == ~s"""
             . . . . o o
             i i i i o o
             o o . . o o
             o o . . o o
             """

      assert Row.full?(board, 0) == false
      assert Row.full?(board, 1) == true
      assert Row.full?(board, 2) == false
      assert Row.full?(board, 3) == false
    end

    test "it handles partial blocks" do
      o_bottom_left = Block.o({0, 2})
      o_bottom_right = Block.o({4, 2})
      o_top_right = Block.o({4, 0})
      half_z_middle = Block.z({2, 2})
      half_z_middle = %{half_z_middle | parts: half_z_middle.parts |> Enum.take(2)}
      half_s_bottom = Block.s({1, 3})
      half_s_bottom = %{half_s_bottom | parts: half_s_bottom.parts |> Enum.take(2)}
      i = Block.i({0, 1})

      board = %Board{
        width: 6,
        height: 4,
        static_blocks: [o_bottom_left, o_bottom_right, o_top_right, half_z_middle, half_s_bottom, i]
      }

      assert inspect(board) == ~s"""
             . . . . o o
             i i i i o o
             o o z z o o
             o o s s o o
             """

      assert Row.full?(board, 0) == false
      assert Row.full?(board, 1) == true
      assert Row.full?(board, 2) == true
      assert Row.full?(board, 3) == true
    end
  end

  describe "remove" do
    test "it removes the row and moves the ones above down" do
      i = Block.i({0, 3})
      o = Block.o({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [i, o]}
      board2 = Row.remove(board, 3)

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . o o
             i i i i o o
             """

      assert inspect(board2) == ~s"""
             . . . . . .
             . . . . . .
             . . . . . .
             . . . . o o
             """
    end

    test "it removes blocks that have no more parts" do
      i = Block.i({0, 3})
      o = Block.o({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [i, o]}
      board2 = Row.remove(board, 3)

      assert board2.static_blocks |> Enum.count() == 1
      assert (board2.static_blocks |> Enum.at(0)).type == :o
    end

    test "does nothing if the row is empty" do
      i = Block.i({0, 3})
      o = Block.o({4, 2})
      board = %Board{width: 6, height: 4, static_blocks: [i, o]}
      board2 = Row.remove(board, 1)

      assert inspect(board) == ~s"""
             . . . . . .
             . . . . . .
             . . . . o o
             i i i i o o
             """

      assert inspect(board2) == ~s"""
             . . . . . .
             . . . . . .
             . . . . o o
             i i i i o o
             """
    end

    test "it doesn't have to be the lowest row" do
      o_bottom_left = Block.o({0, 2})
      o_bottom_right = Block.o({4, 2})
      o_top_right = Block.o({4, 0})
      i = Block.i({0, 1})

      board = %Board{
        width: 6,
        height: 4,
        static_blocks: [o_bottom_left, o_bottom_right, o_top_right, i]
      }

      board2 = Row.remove(board, 2)

      assert inspect(board) == ~s"""
             . . . . o o
             i i i i o o
             o o . . o o
             o o . . o o
             """

      assert inspect(board2) == ~s"""
             . . . . . .
             . . . . o o
             i i i i o o
             o o . . o o
             """
    end
  end
end
