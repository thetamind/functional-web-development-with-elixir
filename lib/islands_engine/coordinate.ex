defmodule IslandsEngine.Coordinate do
  @moduledoc false

  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  def new(row, col) when row in @board_range and col in @board_range do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinate}

  def new!(row, col) do
    case new(row, col) do
      {:ok, coordinate} -> coordinate
      {:error, reason} -> raise(ArgumentError, inspect(reason))
    end
  end

  def offset(%{row: row, col: col}, row_offset, col_offset) do
    Coordinate.new(row + row_offset, col + col_offset)
  end
end
