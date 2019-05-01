defmodule FallingBlocks.Block do
  alias FallingBlocks.Coordinates, as: C

  defstruct parts: [], type: nil

  @type block_type :: :square | :long
  @type t :: %__MODULE__{parts: list(C.t()), type: block_type()}

  @spec block_types() :: list(block_type())
  def block_types() do
    [:square, :long]
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

  @spec square(C.t()) :: t()
  def square(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [
        top_left,
        top_left |> C.down(),
        top_left |> C.down() |> C.right(),
        top_left |> C.right()
      ],
      type: :square
    }
  end

  @spec long(C.t()) :: t()
  def long(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [top_left, top_left |> C.right(1), top_left |> C.right(2), top_left |> C.right(3)],
      type: :long
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
end
