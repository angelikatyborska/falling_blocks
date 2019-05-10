defmodule FallingBlocks.Block do
  require Integer
  alias FallingBlocks.Coordinates, as: C

  defstruct parts: [], type: nil, rotation: 0

  @type block_type :: :o | :i | :t | :j | :l | :z | :s
  @type rotation :: 0 | 1 | 2 | 3
  @type t :: %__MODULE__{parts: list(C.t()), type: block_type(), rotation: rotation()}

  @spec block_types() :: list(block_type())
  def block_types() do
    [:o, :i, :t, :j, :l, :z, :s]
  end

  @doc """
    It moves the block down
  """
  @spec down(t()) :: t()
  def down(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.down/1)}
  end

  @doc """
    It moves the block left
  """
  @spec left(t()) :: t()
  def left(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.left/1)}
  end

  @doc """
    It moves the block right
  """
  @spec right(t()) :: t()
  def right(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.right/1)}
  end

  @doc """
    It moves the block up
  """
  @spec up(t()) :: t()
  def up(%__MODULE__{parts: parts} = block) do
    %{block | parts: Enum.map(parts, &C.up/1)}
  end

  @doc """
    Creates a new block of type O
  """
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

  @doc """
    Creates a new block of type I
  """
  @spec i(C.t()) :: t()
  def i(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [top_left, top_left |> C.right(1), top_left |> C.right(2), top_left |> C.right(3)],
      type: :i
    }
  end

  @doc """
    Creates a new block of type T
  """
  @spec t(C.t()) :: t()
  def t(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [
        top_left |> C.right(1),
        top_left |> C.down(1),
        top_left |> C.right(1) |> C.down(1),
        top_left |> C.right(2) |> C.down(1)
      ],
      type: :t
    }
  end

  @doc """
    Creates a new block of type J
  """
  @spec j(C.t()) :: t()
  def j(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [
        top_left,
        top_left |> C.down(1),
        top_left |> C.down(1) |> C.right(1),
        top_left |> C.down(1) |> C.right(2)
      ],
      type: :j
    }
  end

  @doc """
    Creates a new block of type L
  """
  @spec l(C.t()) :: t()
  def l(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [
        top_left |> C.right(2),
        top_left |> C.down(1),
        top_left |> C.down(1) |> C.right(1),
        top_left |> C.down(1) |> C.right(2)
      ],
      type: :l
    }
  end

  @doc """
    Creates a new block of type Z
  """
  @spec z(C.t()) :: t()
  def z(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [
        top_left,
        top_left |> C.right(1),
        top_left |> C.down(1) |> C.right(1),
        top_left |> C.down(1) |> C.right(2)
      ],
      type: :z
    }
  end

  @doc """
    Creates a new block of type S
  """
  @spec s(C.t()) :: t()
  def s(top_left \\ {0, 0}) do
    %__MODULE__{
      parts: [
        top_left |> C.right(1),
        top_left |> C.right(2),
        top_left |> C.right(1) |> C.down(1),
        top_left |> C.down(1)
      ],
      type: :s
    }
  end

  @doc """
    Counts how many rows a block of a given type will occupy.
  """
  @spec width(__MODULE__.block_type() | __MODULE__.t()) :: integer()
  def width(%__MODULE__{} = block) do
    block
    |> Map.get(:parts)
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
    |> Enum.count()
  end

  def width(block_type) do
    __MODULE__
    |> apply(block_type, [{0, 0}])
    |> width
  end

  @doc """
    Counts how many rows a block of a given type will occupy.
  """
  @spec height(__MODULE__.block_type() | __MODULE__.t()) :: integer()
  def height(%__MODULE__{} = block) do
    block
    |> Map.get(:parts)
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq()
    |> Enum.count()
  end

  def height(block_type) do
    __MODULE__
    |> apply(block_type, [{0, 0}])
    |> height
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
    |> Enum.sort()
  end

  @doc """
    Rotates a block.
  """
  @spec rotate(t()) :: t()
  def rotate(%__MODULE__{type: :o} = block) do
    block
  end

  def rotate(block) do
    rotation_point = rotation_point(block)

    parts =
      block.parts
      |> Enum.map(&C.rotate_90deg_cw(&1, rotation_point))

    %{block | rotation: new_rotation(block), parts: parts}
  end

  defp new_rotation(block) do
    block.rotation
    |> Kernel.+(1)
    |> rem(4)
  end

  defp rotation_point(block) do
    width = width(block)
    height = height(block)

    {dx, dy} =
      if block.type == :i do
        case block.rotation do
          0 -> {(width - 1) / 2, height / 2}
          1 -> {-1 * width / 2, (height - 1) / 2}
          2 -> {(width - 1) / 2, -1 * height / 2}
          3 -> {width / 2, (height - 1) / 2}
        end
      else
        dx =
          if Integer.is_odd(width) do
            trunc(width / 2)
          else
            case block.rotation do
              0 -> trunc(width / 2)
              1 -> trunc((width - 1) / 2)
              2 -> trunc((width - 1) / 2)
              3 -> trunc(width / 2)
            end
          end

        dy =
          if Integer.is_odd(height) do
            trunc(height / 2)
          else
            case block.rotation do
              0 -> trunc(height / 2)
              1 -> trunc((height - 1) / 2)
              2 -> trunc((height - 1) / 2)
              3 -> trunc(height / 2)
            end
          end

        {dx, dy}
      end

    block
    |> top_left()
    |> C.right(dx)
    |> C.down(dy)
  end

  defp top_left(block) do
    top =
      block.parts
      |> Enum.map(&elem(&1, 1))
      |> Enum.min()

    left =
      block.parts
      |> Enum.map(&elem(&1, 0))
      |> Enum.min()

    {left, top}
  end
end
