defmodule FallingBlocks.Board.Row do
  alias FallingBlocks.{Board, Block}

  @doc """
    Checks if every column in a given row has a block in it.
  """
  @spec full?(Board.t(), integer()) :: boolean
  def full?(board, row) do
    all_columns =
      0..(board.width - 1)
      |> Enum.to_list()

    occupied_columns =
      board.static_blocks
      |> Enum.map(& &1.parts)
      |> List.flatten()
      |> Enum.reduce([], fn part, acc ->
        case part do
          {column, ^row} -> [column | acc]
          _ -> acc
        end
      end)

    all_columns -- occupied_columns == []
  end

  @doc """
    Removes a given row and moves all rows above it one down.
  """
  @spec remove(Board.t(), integer()) :: Board.t()
  def remove(board, row) do
    static_blocks =
      board.static_blocks
      |> Enum.map(&Block.remove_row(&1, row))
      |> Enum.filter(& &1)

    %{board | static_blocks: static_blocks}
  end
end
