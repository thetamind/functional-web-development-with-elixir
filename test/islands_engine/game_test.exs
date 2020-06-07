defmodule IslandsEngine.GameTest do
  use ExUnit.Case, async: true

  alias IslandsEngine.Game
  alias IslandsEngine.Rules

  setup do
    {:ok, game} = Game.start_link("Frank")
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

  test "set islands", %{game: game} do
    :ok = Game.add_player(game, "Pebbles")

    assert {:error, :not_all_islands_positioned} = Game.set_islands(game, :player1)

    # Place all islands
    Game.position_island(game, :player1, :atoll, 1, 1)
    Game.position_island(game, :player1, :dot, 1, 4)
    Game.position_island(game, :player1, :l_shape, 1, 5)
    Game.position_island(game, :player1, :s_shape, 5, 1)
    Game.position_island(game, :player1, :square, 5, 5)

    assert {:ok, _board} = Game.set_islands(game, :player1)
  end

  test "guess coordinate", %{game: game} do
    assert :error = Game.guess_coordinate(game, :player1, 1, 1)

    :ok = Game.add_player(game, "Trane")

    # Manually set to player 1 turn
    Game.position_island(game, :player1, :dot, 1, 1)
    Game.position_island(game, :player2, :square, 1, 1)

    :sys.replace_state(game, fn state ->
      %{state | rules: %Rules{state: :player1_turn}}
    end)

    assert {:error, :invalid_coordinate} = Game.guess_coordinate(game, :player1, -5, -5)
    assert {:miss, :none, :no_win} = Game.guess_coordinate(game, :player1, 5, 5)
    # cannot guess twice
    assert :error = Game.guess_coordinate(game, :player1, 3, 1)

    # player 2 win
    assert {:hit, :dot, :win} = Game.guess_coordinate(game, :player2, 1, 1)
  end

  test "game registry requires unique names" do
    {:ok, pid} = Game.start_link("Dino")
    assert {:error, {:already_started, ^pid}} = Game.start_link("Dino")
  end
end
