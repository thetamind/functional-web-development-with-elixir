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
end
