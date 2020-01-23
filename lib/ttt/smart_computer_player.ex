defmodule Ttt.SmartComputerPlayer do
  alias Ttt.Board

  def select_move(board, game_state) do
    minimax(board, game_state, game_state.current_player.marker).space
  end

  def minimax(board, game_state, marker) do
    if is_terminal_board(board, game_state) do
      score(board, game_state)
    else
      available_spaces = Board.available_spaces(board)

      possible_moves =
        Enum.map(available_spaces, fn space ->
          new_board = Board.update(board, space, marker)
          %{
            space: space,
            score: minimax(new_board, game_state, next_player(game_state, marker)).score
          }
        end)

      select_best_move(possible_moves, game_state, marker)
    end
  end

  defp is_terminal_board(board, game_state) do
    Board.is_full?(board) or Board.is_won?(board, game_state.current_player.marker) or Board.is_won?(board, game_state.next_player.marker)
  end

  defp score(board, game_state) do
    cond do
      Board.is_won?(board, game_state.current_player.marker) -> %{score: 10}
      Board.is_won?(board, game_state.next_player.marker) -> %{score: -10}
      true -> %{score: 0}
    end
  end

  defp select_best_move(possible_moves, game_state, marker) do
    player = game_state.current_player.marker
    opponent = game_state.next_player.marker

    case marker do
      ^player -> maximise_score(possible_moves)
      ^opponent -> minimise_score(possible_moves)
    end
  end

  defp maximise_score(possible_moves) do
    Enum.reduce(possible_moves, %{space: nil, score: -1}, fn(move, acc) ->
      if move.score > acc.score, do: move, else: acc
    end)
  end

  defp minimise_score(possible_moves) do
    Enum.reduce(possible_moves, %{space: nil, score: 1}, fn(move, acc) ->
      if move.score < acc.score, do: move, else: acc
    end)
  end

  defp next_player(state = %{current_player: %{marker: marker}}, marker), do: state.next_player.marker
  defp next_player(%{current_player: p}, _marker), do: p.marker
end