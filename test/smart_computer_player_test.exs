defmodule SmartComputerPlayerTest do
  use ExUnit.Case

  alias Ttt.SmartComputerPlayer

  test "selects the last remaining space if only one space remains" do
    board = ["X", "O", "X", "O", "O", "X", "7", "X", "O"]
    state = %{current_player: "O", next_player: "X"}

    assert SmartComputerPlayer.select_move(board, state) == "7"
  end

  test "selects a winning space if available" do
    board = ["1", "2", "3", "O", "O", "6", "7", "8", "9"]
    state = %{current_player: "O", next_player: "X"}

    assert SmartComputerPlayer.select_move(board, state) == "6"
  end

  test "prevents an opponent from winning if possible" do
    board = ["O", "X", "3", "4", "X", "6", "7", "8", "9"]
    state = %{current_player: "O", next_player: "X"}

    assert SmartComputerPlayer.select_move(board, state) == "8"
  end

  test "prefers to win over preventing opponent from winning" do
    board = ["O", "O", "3", "4", "5", "6", "X", "X", "9"]
    state = %{current_player: "O", next_player: "X"}

    assert SmartComputerPlayer.select_move(board, state) == "3"
  end
end