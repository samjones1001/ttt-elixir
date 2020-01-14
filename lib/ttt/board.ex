defmodule Ttt.Board do
  @win_conditions [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]

  def create() do
    ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  def update(board, space, marker) do
    List.replace_at(board, String.to_integer(space) - 1, marker)
  end

  def is_available_space?(board, space) do
    Enum.member?(available_spaces(board), space)
  end

  def is_full?(board) do
    length(available_spaces(board)) == 0
  end

  def is_won?(board) do
    Enum.count(check_for_winning_lines(board), fn(result) -> result == true end) > 0
  end

  defp available_spaces(board) do
    Enum.filter(board, fn(space) -> is_available_space?(space) end)
  end

  defp is_available_space?(space) do
    case Integer.parse(space) do
      {_num, ""} -> true
      _          -> false
    end
  end

  defp check_for_winning_lines(board) do
    Enum.map(@win_conditions, fn(condition) ->
      condition
      |> get_indices(board)
      |> is_winning_line?()
    end)
  end

  defp is_winning_line?(line) do
    marker = List.first(line)
    Enum.count(line, fn(element) -> element == marker end) == 3
  end

  defp get_indices(indices, board) do
    Enum.map(indices, fn(index) -> Enum.at(board, index) end)
  end
end
