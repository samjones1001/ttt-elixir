defmodule Ttt.Board do
  def create() do
    ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  def update(board, space, marker) do
    List.replace_at(board, String.to_integer(space) - 1, marker)
  end

  def available_spaces(board) do
    Enum.filter(board, fn(space) ->
      case Integer.parse(space) do
        {_num, ""} -> true
        _          -> false
      end
    end)
  end
end
