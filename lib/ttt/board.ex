defmodule Ttt.Board do
  def create() do
    ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  def create(board, space, marker) do
    List.replace_at(board, String.to_integer(space) - 1, marker)
  end
end