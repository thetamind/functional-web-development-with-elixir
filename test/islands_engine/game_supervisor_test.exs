defmodule IslandsEngine.GameSupervisorTest do
  use ExUnit.Case, async: true

  alias IslandsEngine.GameSupervisor

  test "start/stop game" do
    {:ok, game} = GameSupervisor.start_game("Cassatt")
    assert Process.alive?(game)
    :ok = GameSupervisor.stop_game("Cassatt")
    refute Process.alive?(game)
  end
end
