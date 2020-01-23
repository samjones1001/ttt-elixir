defmodule Ttt.Game do
  alias Ttt.Board
  alias Ttt.GameStore
  alias Ttt.SimpleComputerPlayer
  alias Ttt.SmartComputerPlayer

  def play(opponent_type, _space=nil, _game_id=nil) do
    board = Board.create()
    game_id = GameStore.start(%{board: board, opponent: opponent_type, current_player: %{type: "Human", marker: "X"}, next_player: %{type: opponent_type, marker: "O"}, error: false})
    %{board: board, game_id: elem(game_id, 1)}
  end

  def play(_opponent=nil, space, game_id) do
    game_id = game_id
    previous_state = GameStore.retrieve(game_id)

    updated_state = if Board.is_available_space?(previous_state.board, space),
       do: run_turn(previous_state, space, game_id),
       else: set_error_message(previous_state, game_id)

    case previous_state.opponent do
      nil -> updated_state
      _   -> computer_turn(updated_state, game_id)
    end
  end

  defp run_turn(previous_state, space, game_id) do
    new_board = place_marker(previous_state, space)
    game_status = evaluate_turn_end_status(new_board, previous_state, space)
    update_game_store(%{board: new_board, opponent: previous_state.opponent, current_player: previous_state.next_player, next_player: previous_state.current_player, game_id: game_id})

    %{board: new_board, game_id: game_id, game_over: game_status.game_over, message: game_status.message, error: false}
  end

  defp place_marker(state, space) do
    Board.update(state.board, space, state.current_player.marker)
  end

  defp evaluate_turn_end_status(board, game_state, space) do
    current_player = game_state.current_player.marker

    case is_game_over?(board, current_player) do
      true -> %{game_over: true, message: build_game_over_message(board, current_player)}
      false -> %{game_over: false, message: build_turn_end_message(game_state, space)}
    end
  end

  defp computer_turn(state, game_id) do
    stored_state = GameStore.retrieve(game_id)

    if !is_game_over?(state.board, stored_state.next_player.marker) and !state.error,
       do: run_turn(stored_state, get_opponent_move(state.board, stored_state), game_id),
       else: state
  end

  defp is_game_over?(board, marker) do
    if Board.is_full?(board) or Board.is_won?(board, marker), do: true, else: false
  end

  defp build_turn_end_message(game_state, space) do
    "#{game_state.next_player.marker}\'s turn. #{game_state.current_player.marker} took space #{space}"
  end

  defp build_game_over_message(board, player) do
    if Board.is_won?(board, player), do: "Game Over - #{player} wins!", else: "Game Over - It's a Tie!"
  end

  defp set_error_message(state, game_id) do
    state
    |> Map.merge(%{message: "Please select an available space", error: true, game_id: game_id})
  end

  defp update_game_store(state) do
    GameStore.update(state.game_id ,%{board: state.board, opponent: state.opponent, current_player: state.current_player, next_player: state.next_player})
  end

  defp get_opponent_move(board, game_state) do
    case game_state.opponent do
      "SimpleComputer" -> SimpleComputerPlayer.select_move(Board.available_spaces(board))
      "SmartComputer" -> SmartComputerPlayer.select_move(board, game_state)
    end
  end
end