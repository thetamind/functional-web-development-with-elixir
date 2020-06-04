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

  describe "when players_set" do
    test "players can position_islands" do
      {:ok, rules} = new() |> check(:add_player)
      {:ok, rules} = check(rules, {:position_islands, :player1})
      {:ok, rules} = check(rules, {:position_islands, :player2})

      assert rules.state == :players_set
    end

    test "a player sets their islands" do
      {:ok, rules} = new() |> check(:add_player)
      {:ok, rules} = check(rules, {:position_islands, :player1})
      {:ok, rules} = check(rules, {:position_islands, :player2})
      {:ok, rules} = check(rules, {:set_islands, :player2})
      {:ok, rules} = check(rules, {:set_islands, :player2})

      assert rules.state == :players_set
    end

    test "both players set their islands transitions to player1_turn" do
      {:ok, rules} = new() |> check(:add_player)
      {:ok, rules} = check(rules, {:position_islands, :player1})
      {:ok, rules} = check(rules, {:position_islands, :player2})
      {:ok, rules} = check(rules, {:set_islands, :player1})
      {:ok, rules} = check(rules, {:set_islands, :player2})

      assert rules.state == :player1_turn
    end
  end
end
