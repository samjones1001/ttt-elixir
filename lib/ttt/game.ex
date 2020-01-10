defmodule Ttt.Game do
  alias Ttt.Board

  def start() do
    Agent.start_link(fn ->
      board = Board.create()
      %{board: board, current_player: "X", message: nil, game_over: false}
    end)
  end

  def get_board_state(pid) do
    Agent.get(pid, fn(state) -> state.board end)
  end

  def get_current_player(pid) do
    Agent.get(pid, fn(state) -> state.current_player end)
  end

  def get_message(pid) do
    Agent.get(pid, fn(state) -> state.message end)
  end

  def play_turn(pid, space) do
    board = get_board_state(pid)
    if Board.is_available_space?(board, space), do: update_game(pid,space), else: set_error_message(pid)
  end

  def is_game_over?(pid) do
    board = get_board_state(pid)
    if Board.is_full?(board), do: true, else: false
  end

  defp update_state(pid, values) do
    Enum.map(values, fn(value) -> update_value(pid, elem(value, 0), elem(value, 1)) end)
  end

  defp update_value(pid, key, value) do
    Agent.update(pid, fn(state) -> Map.put(state, key, value) end)
  end

  defp update_game(pid, space) do
    new_board = place_marker(pid, space)
    next_player_marker = set_next_player_marker(get_current_player(pid))

    update_state(pid, [board: new_board, current_player: next_player_marker, message: nil])
    check_for_game_over(pid)
  end

  defp place_marker(pid, space) do
    Board.update(get_board_state(pid), space, get_current_player(pid))
  end

  defp check_for_game_over(pid) do
    case is_game_over?(pid) do
      true -> update_state(pid, [message: "Game Over!"])
      false -> nil
    end
  end

  defp set_next_player_marker(current_player) do
    if current_player == "X", do: "O", else: "X"
  end

  defp set_error_message(pid) do
    update_state(pid, [message: "Please select an available move"])
  end
end