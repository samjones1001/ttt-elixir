defmodule Ttt.Game do
  alias Ttt.Board
  alias Ttt.GameStore
  alias Ttt.SimpleComputerPlayer
  alias Ttt.SmartComputerPlayer

  def play(options, _game_id=nil) do
    board = Board.create()
    current_player = %{type: options.current_player_type, marker: "X"}
    next_player = %{type: options.next_player_type, marker: "O"}

    game_id = GameStore.start(%{board: board, current_player: current_player, next_player: next_player})
    %{board: board, game_id: elem(game_id, 1), current_player_type: current_player.type}
  end

  def play(options = %{current_player_type: "Human"}, game_id) do
    previous_state = GameStore.retrieve(game_id)
    space = options.move

    if Board.is_available_space?(previous_state.board, space),
       do: run_turn(previous_state, space, game_id),
       else: set_error_message(previous_state, game_id)
  end

  def play(options, game_id) do
    previous_state = GameStore.retrieve(game_id)
    run_turn(previous_state, get_opponent_move(options.current_player_type, previous_state), game_id)
  end

  defp run_turn(previous_state, space, game_id) do
    new_board = place_marker(previous_state, space)
    game_status = evaluate_turn_end_status(new_board, previous_state, space)
    update_game_store(%{board: new_board, current_player: previous_state.next_player, next_player: previous_state.current_player, game_id: game_id})

    %{board: new_board, game_id: game_id, current_player_type: previous_state.next_player.type, game_over: game_status.game_over, message: game_status.message}
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
    %{board: state.board, game_id: game_id, current_player_type: state.current_player.type, game_over: false, message: "Please select an available space"}
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