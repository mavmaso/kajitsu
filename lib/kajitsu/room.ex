defmodule Kajitsu.Room do
  use Agent

  def start_link(name) do
    Agent.start_link(fn -> %{users: 0, votes: %{}} end, name: global_name(name))
  end

  def whereis(name) do
    case :global.whereis_name({__MODULE__, name}) do
      :undefined -> nil
      pid -> pid
    end
  end

  def get(name) do
    Agent.get(global_name(name), & &1)
  end

  def update_votes(name, key, value) do
    Agent.get_and_update(global_name(name), fn %{votes: votes} = state ->
      state = Map.merge(state, %{votes: Map.merge(votes, %{"#{key}" => value})})

      {state, state}
    end)
  end

  defp global_name(name), do: {:global, {__MODULE__, name}}
end
