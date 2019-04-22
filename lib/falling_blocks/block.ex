defmodule FallingBlocks.Block do
  alias FallingBlocks.Coordinates
  import FallingBlocks.Coordinates

  defstruct parts: [], type: nil

  @type block_type :: :square | :long
  @type t :: %__MODULE__{parts: list(Coordinates.t()), type: block_type()}

  @spec advance(t()) :: t()
  def advance(%__MODULE__{parts: parts}) do
    %__MODULE__{parts: Enum.map(parts, &down/1)}
  end

  @spec square(Coordinates.t()) :: t()
  def square(left_top \\ {0, 0}) do
    %__MODULE__{
      parts: [left_top, left_top |> down, left_top |> down |> right, left_top |> right],
      type: :square
    }
  end

  @spec long(Coordinates.t()) :: t()
  def long(left_top \\ {0, 0}) do
    %__MODULE__{
      parts: [left_top, left_top |> right(1), left_top |> right(2), left_top |> right(3)],
      type: :long
    }
  end
end
