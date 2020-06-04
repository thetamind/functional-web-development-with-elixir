defmodule IslandsEngine.RulesTest do
  use ExUnit.Case, async: true

  import IslandsEngine.Rules

  describe "when initialized" do
    test "event add_player transitions to players_set" do
      {:ok, rules} = new() |> check(:add_player)
      assert rules.state == :players_set
    end

    test "invalid event is error" do
      assert :error = new() |> check(:no_not_that_one)
    end
  end
end
