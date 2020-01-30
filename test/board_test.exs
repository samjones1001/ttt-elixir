defmodule BoardTest do
  use ExUnit.Case

  alias Ttt.Board

  describe "board creation" do
    test "create/0 creates an empty board" do
      assert Board.create() == ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "update/3 creates an updated board" do
      board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
      assert Board.update(board, "1", "X") == ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
    end
  end

  describe "is_available_space?" do
    test "a space is available if it is yet to be occupied" do
      board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
      assert Board.is_available_space?(board, "1") == true
    end

    test "a space is not available if it is occupied" do
      board = ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
      assert Board.is_available_space?(board, "1") == false
    end
  end

  describe "is_full?" do
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

  describe "is_won?" do
    test "a game is not won if no spaces are occupied" do
      current_player = "X"
      board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
      assert Board.is_won?(board, current_player) == false
    end

    test "a game is not won if no winning index contains three of the same marker" do
      current_player = "X"
      board = ["X", "O", "X", "O", "X", "X", "O", "X", "O"]
      assert Board.is_won?(board, current_player) == false
    end

    test "a game is won if there are three matching markers on a row" do
      current_player = "X"
      board = ["X", "X", "X", "4", "5", "6", "7", "8", "9"]
      assert Board.is_won?(board, current_player) == true
    end

    test "a game is won if there are three matching markers on a column" do
      current_player = "X"
      board = ["X", "2", "3", "X", "5", "6", "X", "8", "9"]
      assert Board.is_won?(board, current_player) == true
    end

    test "a game is won if there are three matching markers on a diagonal" do
      current_player = "X"
      board = ["X", "2", "3", "4", "X", "6", "7", "8", "X"]
      assert Board.is_won?(board, current_player) == true
    end

    test "returns an empty array if no winning line present" do
      board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
      assert Board.winning_indices(board, "X") == []
    end

    test "returns an array of indices of a winning line if present" do
      board = ["X", "X", "X", "4", "5", "6", "7", "8", "9"]
      assert Board.winning_indices(board, "X") == [0,1,2]
    end
  end
end