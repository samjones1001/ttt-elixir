defmodule Ttt.Game do
  alias Ttt.Board

  def start() do
    Agent.start_link(fn ->
      board = Board.create()
      %{board: board, current_player: "X", message: nil}
    end)
  end

  def get_board_state(pid) do
    Agent.get(pid, fn(state) -> state.board end)
  end

  def get_message(pid) do
    Agent.get(pid, fn(state) -> state.message end)
  end

  def play_turn(pid, space) do
    board = get_board_state(pid)
    if Board.is_available_space?(board, space), do: update_game_state(pid,space), else: set_error_message(pid)
  end

  def is_game_over?(pid) do
    board = get_board_state(pid)
    if Board.is_full?(board), do: true, else: false
  end

  defp update_game_state(pid, space) do
    place_marker(pid, space)
    check_for_game_over(pid)
  end

  defp place_marker(pid, space) do
    Agent.update(pid, fn(state) ->
      board = Board.update(state.board, space, state.current_player)
      %{board: board, current_player: set_next_player_marker(state.current_player), message: nil}
    end)
  end

  defp check_for_game_over(pid) do
    case is_game_over?(pid) do
      true -> Agent.update(pid, fn(state) -> Map.put(state, :message, "Game Over!") end)
      false -> nil
    end
  end

  defp set_next_player_marker(current_player) do
    if current_player == "X", do: "O", else: "X"
  end

  defp set_error_message(pid) do
    Agent.update(pid, fn(state) -> Map.put(state, :message, "Please select an available move") end)
  end
end