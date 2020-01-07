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
end