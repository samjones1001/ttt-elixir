defmodule Ttt.Game do
  alias Ttt.Board
  alias Ttt.GameStore
  alias Ttt.SimpleComputerPlayer

  def play(opponent, _space=nil, _game_id=nil) do
    board = Board.create()
    game_id = GameStore.start(%{board: board, opponent: opponent, current_player: "X"})
    update_game_state(%{board: board}, %{board: board, game_id: game_id_to_string(game_id)})
  end

  def play(_opponent=nil, space, game_id) do
    previous_state = GameStore.retrieve(game_id_to_pid(game_id))

    updated_state = if Board.is_available_space?(previous_state.board, space),
       do: update_game(previous_state, space, game_id_to_pid(game_id)),
       else: set_error_message(previous_state, game_id_to_pid(game_id))

    case previous_state.opponent do
      nil -> updated_state
      _   -> if !is_game_over?(updated_state.board), do: update_game(GameStore.retrieve(game_id_to_pid(game_id)), get_opponent_move(previous_state.opponent, updated_state.board), game_id_to_pid(game_id)), else: updated_state
    end
  end

  defp update_game(previous_state, space, game_id) do
    new_board = place_marker(previous_state, space)
    game_over_status = check_for_game_over(new_board)
    update_game_store(new_board, previous_state.opponent ,set_next_player_marker(previous_state.current_player), game_id)

    update_game_state(%{board: new_board}, %{game_id: String.slice(inspect(:erlang.pid_to_list(game_id)), 2..-3), game_over: game_over_status.game_over, message: game_over_status.message})
  end

  defp place_marker(state, space) do
    Board.update(state.board, space, state.current_player)
  end

  defp check_for_game_over(board) do
    case is_game_over?(board) do
      true -> %{game_over: true, message: "Game Over!"}
      false -> %{game_over: false, message: nil}
    end
  end

  defp is_game_over?(board) do
    if Board.is_full?(board) or Board.is_won?(board), do: true, else: false
  end

  defp set_next_player_marker(current_player) do
    if current_player == "X", do: "O", else: "X"
  end

  defp set_error_message(state, game_id) do
    update_game_state(state, %{message: "Please select an available space", game_id: String.slice(inspect(:erlang.pid_to_list(game_id)), 2..-3)})
  end

  defp update_game_state(state, new_values) do
    %{board: state.board}
    |> Map.merge(new_values)
  end

  defp update_game_store(board, opponent, player, game_id) do
    GameStore.update(game_id ,%{board: board, opponent: opponent, current_player: player})
  end

  defp game_id_to_string(game_id) do
    String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
  end

  def game_id_to_pid(game_id_string) do
    :erlang.list_to_pid('<#{game_id_string}>')
  end

  defp get_opponent_move(opponent_type, board) do
    SimpleComputerPlayer.select_move(Board.available_spaces(board))
  end
end