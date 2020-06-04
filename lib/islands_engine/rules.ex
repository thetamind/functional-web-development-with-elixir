defmodule IslandsEngine.Rules do
  @moduledoc false

  alias __MODULE__

  defstruct state: :initialized,
            player1: :islands_not_set,
            player2: :islands_not_set

  def new(), do: %Rules{}

  def check(%Rules{state: :initialized} = rules, :add_player) do
    {:ok, %Rules{rules | state: :players_set}}
  end

  def check(_state, _action), do: :error
end
