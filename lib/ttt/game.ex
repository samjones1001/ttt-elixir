defmodule Ttt.Game do
  alias Ttt.Board

  def start() do
    Agent.start_link(fn ->
      board = Board.create()
      %{board: board, current_player: "X"}
    end)
  end

  def get_board_state(pid) do
    Agent.get(pid, fn(state) -> state.board end)
  end

  def get_current_player(pid) do
    Agent.get(pid, fn(state) -> state.current_player end)
  end

  def play_turn(pid, space) do
    Agent.update(pid, fn(state) ->
      %{board: Board.create(state.board, space, state.current_player), current_player: set_next_player_marker(state.current_player)}
    end)
  end

  defp set_next_player_marker(current_player) do
    if current_player == "X", do: "O", else: "X"
  end
end