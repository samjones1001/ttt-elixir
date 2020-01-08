defmodule BoardTest do
  use ExUnit.Case

  alias Ttt.Board

  test "create/0 creates an empty board" do
    assert Board.create() == ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  test "update/3 creates an updated board" do
    board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    assert Board.update(board, "1", "X") == ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
  end
end