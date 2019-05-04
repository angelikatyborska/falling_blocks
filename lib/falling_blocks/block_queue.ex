defmodule FallingBlocks.BlockQueue do
  alias FallingBlocks.Block

  @type t :: list(Block.block_type())

  @length 3

  @spec new() :: __MODULE__.t()
  def new() do
    1..@length
    |> Enum.map(fn _ -> generate_new_block() end)
  end

  @spec pop(__MODULE__.t()) :: {Block.block_type(), __MODULE__.t()}
  def pop([h | t]) do
    {h, t ++ [generate_new_block()]}
  end

  defp generate_new_block() do
    n = :rand.uniform(Enum.count(Block.block_types()))
    Enum.at(Block.block_types(), n - 1)
  end
end
