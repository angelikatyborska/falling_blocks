defmodule FallingBlocks.BlockQueueTest do
  use ExUnit.Case

  alias FallingBlocks.{Block, BlockQueue}

  describe "new" do
    test "it returns a list of random known block types" do
      queue = BlockQueue.new()
      assert is_list(queue)
      assert Enum.uniq(queue) -- Block.block_types() == []
    end
  end

  describe "pop" do
    test "it takes an element from the beginning and appends a new one" do
      queue = BlockQueue.new()
      {el, new_queue} = BlockQueue.pop(queue)

      assert el == hd(queue)
      assert Enum.at(queue, 1) == Enum.at(new_queue, 0)
      assert Enum.at(queue, 2) == Enum.at(new_queue, 1)

      {el2, queue2} = BlockQueue.pop(new_queue)
      {el3, _} = BlockQueue.pop(queue2)

      assert [el, el2, el3] == queue
    end

    test "all types are equally likely" do
      queue = BlockQueue.new()
      n = 1_000_000
      precision = 100
      target_probability = (precision / Enum.count(Block.block_types())) |> round()

      probabilities =
        0..n
        |> Enum.reduce({[], queue}, fn _, {acc, queue} ->
          {val, queue} = BlockQueue.pop(queue)
          {[val | acc], queue}
        end)
        |> elem(0)
        |> Enum.group_by(& &1)
        |> Enum.map(fn {type, list} -> {type, Enum.count(list) / n} end)

      assert Enum.all?(probabilities, fn {_, x} -> round(precision * x) == target_probability end)
    end
  end
end
