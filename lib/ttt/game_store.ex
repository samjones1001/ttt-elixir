defmodule Ttt.GameStore do
  def start(initial_state) do
    Agent.start_link(fn ->
      initial_state
    end)
  end

  def retrieve(pid) do
    Agent.get(pid, fn(state) -> state end)
  end

  def update(pid, new_state) do
    Enum.map(new_state, fn(value) ->
      update_value(pid, elem(value, 0), elem(value, 1))
    end)
  end

  defp update_value(pid, key, value) do
    Agent.update(pid, fn(state) -> Map.put(state, key, value) end)
  end
end