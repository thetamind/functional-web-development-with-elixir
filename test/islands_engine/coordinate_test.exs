defmodule IslandsEngine.CoordinateTest do
  use ExUnit.Case, async: true

  alias IslandsEngine.Coordinate

  describe "new/2" do
    test "builds valid coordinate" do
      assert {:ok, _} = Coordinate.new(1, 1)
    end

    test "errors when coordinate off board" do
      assert {:error, :invalid_coordinate} = Coordinate.new(-1, -1)
      assert {:error, :invalid_coordinate} = Coordinate.new(11, 1)
    end
  end
end
