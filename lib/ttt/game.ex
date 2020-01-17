defmodule Ttt.Game do
  alias Ttt.Board
  alias Ttt.GameStore
  alias Ttt.SimpleComputerPlayer

  def play(opponent, _space=nil, _game_id=nil) do
    board = Board.create()
    game_id = GameStore.start(%{board: board, opponent: opponent, current_player: "X", next_player: "O", error: false})
    %{board: board, game_id: game_id_to_string(elem(game_id, 1))}
  end

  def play(_opponent=nil, space, game_id) do
    game_id = game_id_to_pid(game_id)
    previous_state = GameStore.retrieve(game_id)

    updated_state = if Board.is_available_space?(previous_state.board, space),
       do: run_turn(previous_state, space, game_id),
       else: set_error_message(previous_state, game_id)

    case previous_state.opponent do
      nil -> updated_state
      _   -> if !is_game_over?(updated_state.board) and !updated_state.error,
                do: run_turn(GameStore.retrieve(game_id), get_opponent_move(updated_state.board), game_id),
                else: updated_state
    end
  end

  defp run_turn(previous_state, space, game_id) do
    new_board = place_marker(previous_state, space)
    game_status = evaluate_turn_end_status(new_board, previous_state, space)
    update_game_store(%{board: new_board, opponent: previous_state.opponent, current_player: previous_state.next_player, next_player: previous_state.current_player, game_id: game_id})

    %{board: new_board, game_id: game_id_to_string(game_id), game_over: game_status.game_over, message: game_status.message, error: false}
  end

  defp place_marker(state, space) do
    Board.update(state.board, space, state.current_player)
  end

  defp evaluate_turn_end_status(board, game_state, space) do
    case is_game_over?(board) do
      true -> %{game_over: true, message: build_game_over_message(board, game_state)}
      false -> %{game_over: false, message: build_turn_end_message(game_state, space)}
    end
  end

  defp is_game_over?(board) do
    if Board.is_full?(board) or Board.is_won?(board), do: true, else: false
  end

  defp build_turn_end_message(game_state, space) do
    "#{game_state.next_player}\'s turn. #{game_state.current_player} took space #{space}"
  end

  defp build_game_over_message(board, game_state) do
    if Board.is_won?(board), do: "Game Over - #{game_state.current_player} wins!", else: "Game Over - It's a Tie!"
  end

  defp set_error_message(state, game_id) do
    state
    |> Map.merge(%{message: "Please select an available space", error: true, game_id: game_id_to_string(game_id)})
  end

  defp update_game_store(state) do
    GameStore.update(state.game_id ,%{board: state.board, opponent: state.opponent, current_player: state.current_player, next_player: state.next_player})
  end

  defp game_id_to_string(game_id) do
    String.slice(inspect(:erlang.pid_to_list(game_id)), 2..-3)
  end

  def game_id_to_pid(game_id_string) do
    :erlang.list_to_pid('<#{game_id_string}>')
  end

  defp get_opponent_move(board) do
    SimpleComputerPlayer.select_move(Board.available_spaces(board))
  end
end