defmodule IslandsEngine.GameTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Game

  setup do
    game = start_supervised!({Game, "Frank"})
    %{game: game}
  end

  test "add player", %{game: game} do
    assert :ok = Game.add_player(game, "Dweezil")
  end

  test "position island", %{game: game} do
    :ok = Game.add_player(game, "Wilma")
    assert :ok = Game.position_island(game, :player1, :square, 1, 1)

    assert {:error, :invalid_coordinate} = Game.position_island(game, :player1, :square, 12, 1)
    assert {:error, :invalid_island_type} = Game.position_island(game, :player1, :wrong, 1, 1)
    assert {:error, :invalid_coordinate} = Game.position_island(game, :player1, :l_shape, 10, 10)
    assert {:error, :overlapping_island} = Game.position_island(game, :player1, :dot, 1, 1)
  end
end
