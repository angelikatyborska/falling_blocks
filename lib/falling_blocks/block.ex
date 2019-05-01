defmodule FallingBlocks.Block do
  alias FallingBlocks.Coordinates, as: C

  defstruct parts: [], type: :square

  @type block_type :: :square | :long
  @type t :: %__MODULE__{parts: list(C.t()), type: block_type()}

  @spec advance(t()) :: t()
  def advance(%__MODULE__{parts: parts}) do
    %__MODULE__{parts: Enum.map(parts, &C.down/1)}
  end

  @spec left(t()) :: t()
  def left(%__MODULE__{parts: parts}) do
    %__MODULE__{parts: Enum.map(parts, &C.left/1)}
  end

  @spec right(t()) :: t()
  def right(%__MODULE__{parts: parts}) do
    %__MODULE__{parts: Enum.map(parts, &C.right/1)}
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
end
