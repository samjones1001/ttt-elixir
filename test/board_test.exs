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

  test "a line does not win if no spaces are filled" do
    line = ["1", "2", "3"]
    assert Board.is_winning_line?(line) == false
  end

  test "a line does not win if only some spaces are filled" do
    line = ["X", "X", "3"]
    assert Board.is_winning_line?(line) == false
  end

  test "a line does not win if all markers do not match" do
    line = ["X", "X", "O"]
    assert Board.is_winning_line?(line) == false
  end

  test "a line wins if all markers match" do
    line = ["X", "X", "X"]
    assert Board.is_winning_line?(line) == true
  end
end