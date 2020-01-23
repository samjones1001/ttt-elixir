defmodule Ttt.Game do
  alias Ttt.Board
  alias Ttt.GameStore
  alias Ttt.SimpleComputerPlayer
  alias Ttt.SmartComputerPlayer

  def play(opponent_type, _space=nil, _game_id=nil) do
    board = Board.create()
    first_player_type = "Human"
    game_id = GameStore.start(%{board: board, current_player: %{type: first_player_type, marker: "X"}, next_player: %{type: opponent_type, marker: "O"}, error: false})
    %{board: board, game_id: elem(game_id, 1), player_type: first_player_type}
  end

  def play(_player_type="Human", space, game_id) do
    previous_state = GameStore.retrieve(game_id)

    if Board.is_available_space?(previous_state.board, space),
       do: run_turn(previous_state, space, game_id),
       else: set_error_message(previous_state, game_id)
  end

  def play(player_type, _space=nil, game_id) do
    previous_state = GameStore.retrieve(game_id)
    run_turn(previous_state, get_opponent_move(player_type, previous_state), game_id)
  end

  defp run_turn(previous_state, space, game_id) do
    new_board = place_marker(previous_state, space)
    game_status = evaluate_turn_end_status(new_board, previous_state, space)
    update_game_store(%{board: new_board, current_player: previous_state.next_player, next_player: previous_state.current_player, game_id: game_id})

    %{board: new_board, game_id: game_id, player_type: previous_state.next_player.type, game_over: game_status.game_over, message: game_status.message, error: false}
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
    GameStore.update(state.game_id ,%{board: state.board, current_player: state.current_player, next_player: state.next_player})
  end

  defp get_opponent_move(player_type, game_state) do
    case player_type do
      "SimpleComputer" -> SimpleComputerPlayer.select_move(Board.available_spaces(game_state.board))
      "SmartComputer" -> SmartComputerPlayer.select_move(game_state.board, game_state)
    end
  end
end