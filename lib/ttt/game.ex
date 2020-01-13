defmodule Ttt.Game do
  alias Ttt.Board

  def play(_move=nil, _state=nil) do
    board = Board.create()
    %{board: board, private_state: Jason.encode!(%{board: board, current_player: "X"})}
  end

  def play(move, state) do
    decoded_state = Jason.decode!(state)
    if Board.is_available_space?(Map.get(decoded_state, "board"), move), do: update_game(decoded_state, move), else: set_error_message(decoded_state)
  end

  def is_game_over?(board) do
    if Board.is_full?(board), do: true, else: false
  end

  defp update_game(decoded_state, space) do
    new_board = place_marker(decoded_state, space)
    game_over_status = check_for_game_over(new_board)
    %{board: new_board, message: game_over_status.message, game_over: game_over_status.game_over, private_state: Jason.encode!(%{board: new_board, current_player: set_next_player_marker(Map.get(decoded_state, "current_player"))})}
  end

  defp place_marker(decoded_state, space) do
    Board.update(Map.get(decoded_state, "board"), space, Map.get(decoded_state, "current_player"))
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
    %{board: Map.get(decoded_state, "board"), message: "Please select an available space", private_state: Jason.encode!(%{board: Map.get(decoded_state, "board"), current_player: Map.get(decoded_state, "current_player")})}
  end
end