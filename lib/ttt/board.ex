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

  def is_winning_line?(line) do
    marker = List.first(line)
    Enum.count(line, fn(element) -> element == marker end) == 3
  end

  defp is_available_space?(space) do
    case Integer.parse(space) do
      {_num, ""} -> true
      _          -> false
    end
  end
end
