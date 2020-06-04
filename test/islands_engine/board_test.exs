defmodule IslandsEngine.BoardTest do
  use ExUnit.Case, async: true

  alias IslandsEngine.Board
  alias IslandsEngine.Coordinate
  alias IslandsEngine.Island

  def island!(type, row, col) do
    {:ok, island} = Island.new(type, Coordinate.new!(row, col))
    island
  end

  describe "guess/2" do
    test "putting it all together" do
      square = island!(:square, 1, 1)

      board =
        Board.new()
        |> Board.position_island(:square, square)

      dot = island!(:dot, 2, 2)
      assert {:error, :overlapping_island} = Board.position_island(board, :dot, dot)

      dot = island!(:dot, 3, 3)
      board = Board.position_island(board, :dot, dot)

      assert {:miss, :none, :no_win, board} = Board.guess(board, Coordinate.new!(10, 10))

      assert {:hit, :none, :no_win, board} = Board.guess(board, Coordinate.new!(1, 1))

      # manually mark square as forested
      square = %{square | hit_coordinates: square.coordinates}
      board = Board.position_island(board, :square, square)

      # leaving hitting dot for the win
      assert {:hit, :dot, :win, _board} = Board.guess(board, Coordinate.new!(3, 3))
    end
  end

  describe "position_island/3" do
    test "places island on board" do
      {:ok, square} = Island.new(:square, Coordinate.new!(1, 1))
      {:ok, l_shape} = Island.new(:l_shape, Coordinate.new!(5, 5))

      board =
        Board.new()
        |> Board.position_island(:square, square)
        |> Board.position_island(:l_shape, l_shape)

      assert Map.get(board, :square)
      assert Map.get(board, :l_shape)
    end

    test "replaces island of the same type ignoring overlap" do
      {:ok, square} = Island.new(:square, Coordinate.new!(1, 1))

      board =
        Board.new()
        |> Board.position_island(:square, square)

      {:ok, new_square} = Island.new(:square, Coordinate.new!(2, 2))
      board = Board.position_island(board, :square, new_square)
      assert Map.get(board, :square) == new_square
    end

    test "errors when island overlapping" do
      {:ok, square} = Island.new(:square, Coordinate.new!(1, 1))
      {:ok, dot} = Island.new(:dot, Coordinate.new!(1, 2))

      board =
        Board.new()
        |> Board.position_island(:square, square)

      assert {:error, :overlapping_island} = Board.position_island(board, :dot, dot)
    end
  end

  test "all_islands_positioned?/1" do
    {:ok, square} = Island.new(:square, Coordinate.new!(1, 1))
    {:ok, dot} = Island.new(:dot, Coordinate.new!(3, 1))
    {:ok, l_shape} = Island.new(:l_shape, Coordinate.new!(5, 5))
    {:ok, s_shape} = Island.new(:s_shape, Coordinate.new!(8, 5))

    board =
      Board.new()
      |> Board.position_island(:square, square)
      |> Board.position_island(:dot, dot)
      |> Board.position_island(:l_shape, l_shape)
      |> Board.position_island(:s_shape, s_shape)

    refute Board.all_islands_positioned?(board)

    {:ok, atoll} = Island.new(:atoll, Coordinate.new!(1, 4))

    board = Board.position_island(board, :atoll, atoll)

    assert Board.all_islands_positioned?(board)
  end
end
