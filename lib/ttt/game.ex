defmodule Ttt.Game do
  alias Ttt.Board

  def play(_move=nil, _state=nil) do
    board = Board.create()
    update_game_state(%{board: board, current_player: "X"}, %{board: board})
  end

  def play(space, previous_state) do
    decoded_state = json_state_to_map(previous_state)
    if Board.is_available_space?(decoded_state.board, space),
       do: update_game(decoded_state, space),
       else: set_error_message(decoded_state)
  end

  def is_game_over?(board) do
    if Board.is_full?(board), do: true, else: false
  end

  defp update_game(decoded_state, space) do
    new_board = place_marker(decoded_state, space)
    game_over_status = check_for_game_over(new_board)
    new_private_state = update_private_state(new_board, set_next_player_marker(decoded_state.current_player))

    update_game_state(new_private_state, %{game_over: game_over_status.game_over, message: game_over_status.message})
  end

  defp place_marker(decoded_state, space) do
    Board.update(decoded_state.board, space, decoded_state.current_player)
  end

  defp check_for_game_over(board) do
    case is_game_over?(board) do
      true -> %{game_over: true, message: "Game Over!"}
      false -> %{game_over: false, message: nil}
    end
  end

  defp set_next_player_marker(current_player) do
    if current_player == "X", do: "O", else: "X"
  end

  defp set_error_message(decoded_state) do
    update_game_state(decoded_state, %{message: "Please select an available space"})
  end

  defp update_game_state(state, new_values) do
    new_state = %{board: state.board, private_state: Jason.encode!(state)}
    Map.merge(new_state, new_values)
  end

  defp update_private_state(board, player) do
    %{board: board, current_player: player}
  end

  defp json_state_to_map(json_state) do
    Jason.decode!(json_state)
    |> Map.new(fn {key, value} -> {String.to_atom(key), value} end)
  end
end