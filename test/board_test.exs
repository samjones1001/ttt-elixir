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

  test "all spaces on an empty board are available" do
    board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    assert length(Board.available_spaces(board)) == 9
  end

  test "an occupied space is no longer available" do
    board = ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
    assert length(Board.available_spaces(board)) == 8
  end

  test "a fully occupied board has no available spaces" do
    board = ["X", "X", "X", "X", "X", "X", "X", "X", "X"]
    assert length(Board.available_spaces(board)) == 0
  end

  test "a space is available if it is yet to be occupied" do
    board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    assert Board.is_available_space?(board, "1") == true
  end

  test "a space is not available if it is occupied" do
    board = ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
    assert Board.is_available_space?(board, "1") == false
  end

  test "a board is not full if no spaces are occupied" do
    board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    assert Board.is_full?(board) == false
  end

  test "a board is not full if only some spaces are occupied" do
    board = ["X", "X", "X", "4", "5", "6", "7", "8", "9"]
    assert Board.is_full?(board) == false
  end

  test "a board is full if all spaces are occupied" do
    board = ["X", "X", "X", "X", "X", "X", "X", "X", "X"]
    assert Board.is_full?(board) == true
  end
end
