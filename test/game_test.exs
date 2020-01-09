defmodule GameTest do
  use ExUnit.Case, async: true

  alias Ttt.Game

  setup do
    {:ok, game} = Game.start()
    %{game: game}
  end

  test "begins with an empty board", %{game: game} do
    assert Game.get_board_state(game) == ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  test "playing a turn updates the board", %{game: game} do
    Game.play_turn(game, "1")

    assert Game.get_board_state(game) == ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  test "player 2's turn follows player 1's", %{game: game} do
    Game.play_turn(game, "1")
    Game.play_turn(game, "2")

    assert Game.get_board_state(game) == ["X", "O", "3", "4", "5", "6", "7", "8", "9"]
  end

  test "reverts to players 1's turn after player 2", %{game: game} do
    Game.play_turn(game, "1")
    Game.play_turn(game, "2")
    Game.play_turn(game, "3")

    assert Game.get_board_state(game) == ["X", "O", "X", "4", "5", "6", "7", "8", "9"]
  end

  test "previously occupied spaces can not be overwritten", %{game: game} do
    Game.play_turn(game, "1")
    Game.play_turn(game, "1")

    assert Game.get_board_state(game) == ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  test "current player does not switch until a valid move has been made", %{game: game} do
    Game.play_turn(game, "1")
    Game.play_turn(game, "1")
    Game.play_turn(game, "2")

    assert Game.get_board_state(game) == ["X", "O", "3", "4", "5", "6", "7", "8", "9"]
  end

  test "an error message is set when an invalid move is attempted", %{game: game} do
    Game.play_turn(game, "1")
    Game.play_turn(game, "1")

    assert Game.get_error_message(game) == "Please select an available move"
  end

  test "error message is reset once a valid move is attempted", %{game: game} do
    Game.play_turn(game, "1")
    Game.play_turn(game, "1")
    Game.play_turn(game, "2")

    assert Game.get_error_message(game) == nil
  end
end