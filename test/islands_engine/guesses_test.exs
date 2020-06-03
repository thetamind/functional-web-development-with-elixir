defmodule IslandsEngine.GuessesTest do
  use ExUnit.Case, async: true

  alias IslandsEngine.Coordinate
  alias IslandsEngine.Guesses

  test "tracks unique hits" do
    guesses = Guesses.new()
    {:ok, coordinate1} = Coordinate.new(1, 1)
    {:ok, coordinate2} = Coordinate.new(2, 2)

    guesses = Guesses.add(guesses, :hit, coordinate1)
    guesses = Guesses.add(guesses, :hit, coordinate2)
    guesses = Guesses.add(guesses, :hit, coordinate1)

    assert Enum.count(guesses.hits) == 2
  end

  test "tracks unique misses" do
    guesses = Guesses.new()
    {:ok, coordinate1} = Coordinate.new(1, 1)
    {:ok, coordinate2} = Coordinate.new(2, 2)

    guesses = Guesses.add(guesses, :miss, coordinate1)
    guesses = Guesses.add(guesses, :miss, coordinate2)
    guesses = Guesses.add(guesses, :miss, coordinate1)

    assert Enum.count(guesses.misses) == 2
  end
end
