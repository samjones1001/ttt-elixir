defmodule Ttt.Game do
  alias Ttt.Board

  def start() do
    Agent.start_link(fn ->
      Board.create()
    end)
  end

  def get_board_state(pid) do
    Agent.get(pid, fn(state) ->
      state
    end)
  end

  def update_board_state(pid, space) do
    Agent.update(pid, fn(state) ->
      Board.create(state, space)
    end)
  end
end