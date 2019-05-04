defmodule FallingBlocks.Block do
  alias FallingBlocks.Coordinates, as: C

  defstruct parts: [], type: nil

  @type block_type :: :o | :i
  @type t :: %__MODULE__{parts: list(C.t()), type: block_type()}

  @spec block_types() :: list(block_type())
  def block_types() do
    [:o, :i]
  end

  @spec advance(t()) :: t()
  def advance(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.down/1)}
  end

  @spec left(t()) :: t()
  def left(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.left/1)}
  end

  @spec right(t()) :: t()
  def right(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.right/1)}
  end

  @spec up(t()) :: t()
  def up(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.up/1)}
  end

  @spec o(C.t()) :: t()
  def o(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [
        top_left,
        top_left |> C.down(),
        top_left |> C.down() |> C.right(),
        top_left |> C.right()
      ],
      type: :o
    }
  end

  @spec i(C.t()) :: t()
  def i(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [top_left, top_left |> C.right(1), top_left |> C.right(2), top_left |> C.right(3)],
      type: :i
    }
  end

  @spec width(__MODULE__.block_type()) :: integer()
  def width(block_type) do
    __MODULE__
    |> apply(block_type, [{0, 0}])
    |> Map.get(:parts)
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
    |> Enum.count()
  end

  @doc """
    Removes those parts of the block that lie at the given row.
    Moves down all parts that lie above the given row.
    Returns nil if the block no longer has any parts.
  """
  @spec remove_row(t(), integer()) :: t() | nil
  def remove_row(block, row) do
    parts =
      block.parts
      |> Enum.filter(fn {_, part_row} -> part_row != row end)
      |> Enum.map(fn {column, part_row} ->
        if part_row < row do
          {column, part_row + 1}
        else
          {column, part_row}
        end
      end)

    case parts do
      [] -> nil
      parts -> %{block | parts: parts}
    end
  end

  @doc """
    Returns a list of rows occupied by this block
  """
  @spec rows(t()) :: list(integer())
  def rows(block) do
    block.parts
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq()
  end
end
