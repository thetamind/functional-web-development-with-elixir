defmodule IslandsEngine.GameTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Game

  setup do
    game = start_supervised!({Game, "Frank"})
    %{game: game}
  end

  describe "setup" do
    test "add players", %{game: game} do
      assert :ok = Game.add_player(game, "Dweezil")
    end
  end
end
