defmodule Ttt.Board do
  @win_conditions [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]

  def create() do
    ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  def update(board, space, marker) do
    List.replace_at(board, String.to_integer(space) - 1, marker)
  end

  def available_spaces(board) do
    Enum.filter(board, fn(space) -> is_available_space?(space) end)
  end

  def is_available_space?(board, space) do
    Enum.member?(available_spaces(board), space)
  end

  def is_full?(board) do
    length(available_spaces(board)) == 0
  end

  def is_won?(board, player_marker) do
    length(Enum.filter(check_for_winning_lines(board, player_marker), fn(line) -> elem(line, 0) == true end)) > 0
  end

  def winning_indices(board, player_marker) do
    winning_line = Enum.filter(check_for_winning_lines(board, player_marker), fn(line) -> elem(line, 0) == true end)
    if length(winning_line) > 0, do: elem(Enum.at(winning_line, 0), 1), else: []
  end

  defp is_available_space?(space) do
    case Integer.parse(space) do
      {_num, ""} -> true
      _          -> false
    end
  end

  defp check_for_winning_lines(board, player_marker) do
    Enum.map(@win_conditions, fn(condition) ->
      line = get_indices(condition, board)
      result = is_winning_line?(line, player_marker)
      {result, condition}
    end)
  end

  defp is_winning_line?(line, marker) do
    Enum.count(line, fn(element) -> element == marker end) == 3
  end

  defp get_indices(indices, board) do
    Enum.map(indices, fn(index) -> Enum.at(board, index) end)
  end
end
