defmodule IslandsEngine.IslandTest do
  use ExUnit.Case, async: true

  alias IslandsEngine.Coordinate
  alias IslandsEngine.Island

  describe "new/2" do
    test "creates island" do
      assert {:ok, _} = Island.new(:l_shape, Coordinate.new!(4, 6))
    end

    test "errors when invalid island type" do
      assert {:error, :invalid_island_type} = Island.new(:wrong, Coordinate.new!(4, 6))
    end

    test "errors when island is off board" do
      assert {:error, :invalid_coordinate} = Island.new(:l_shape, Coordinate.new!(10, 10))
    end
  end

  describe "guess/2" do
    test "hits island" do
      {:ok, island} = Island.new(:square, Coordinate.new!(5, 5))
      guess = Coordinate.new!(6, 6)
      assert {:hit, new_island} = Island.guess(island, guess)
      assert MapSet.member?(new_island.hit_coordinates, guess)
    end

    test "misses island" do
      {:ok, island} = Island.new(:dot, Coordinate.new!(1, 2))
      assert :miss = Island.guess(island, Coordinate.new!(5, 5))
    end
  end

  test "overlaps?/2" do
    {:ok, square} = Island.new(:square, Coordinate.new!(1, 1))
    {:ok, dot} = Island.new(:dot, Coordinate.new!(1, 2))
    {:ok, l_shape} = Island.new(:l_shape, Coordinate.new!(5, 5))

    assert Island.overlaps?(square, dot)
    refute Island.overlaps?(square, l_shape)
    refute Island.overlaps?(dot, l_shape)
  end
end
