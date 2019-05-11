defmodule FallingBlocks.ScoreTest do
  use ExUnit.Case
  alias FallingBlocks.Score

  describe "lines_cleared" do
    test "1 line" do
      assert Score.lines_cleared(1, 1) == 40
      assert Score.lines_cleared(2, 1) == 80
      assert Score.lines_cleared(3, 1) == 120
      assert Score.lines_cleared(4, 1) == 160
    end

    test "2 lines" do
      assert Score.lines_cleared(1, 2) == 100
      assert Score.lines_cleared(2, 2) == 200
      assert Score.lines_cleared(3, 2) == 300
      assert Score.lines_cleared(4, 2) == 400
    end

    test "3 lines" do
      assert Score.lines_cleared(1, 3) == 300
      assert Score.lines_cleared(2, 3) == 600
      assert Score.lines_cleared(3, 3) == 900
      assert Score.lines_cleared(4, 3) == 1200
    end

    test "4 lines" do
      assert Score.lines_cleared(1, 4) == 1200
      assert Score.lines_cleared(2, 4) == 2400
      assert Score.lines_cleared(3, 4) == 3600
      assert Score.lines_cleared(4, 4) == 4800
    end
  end
end
