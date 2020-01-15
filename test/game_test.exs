defmodule GameTest do
  use ExUnit.Case

  alias Ttt.Game
  alias Ttt.Board

  describe "play" do
    test "creates a new game if passed no arguments" do
      game_state = Game.play(nil,nil, nil)
      assert game_state.board == ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "updates the board if provided arguments" do
      move = "1"
      json_game_state = '{"board":["1","2","3","4","5","6","7","8","9"],"current_player":"X","opponent":null}'

      game_state = Game.play(nil, move, json_game_state)

      assert game_state.board == ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "places the correct marker dependent on current_player in the passed state" do
      move = "1"
      json_game_state = '{"board":["1","2","3","4","5","6","7","8","9"],"current_player":"O","opponent":null}'

      game_state = Game.play(nil, move, json_game_state)

      assert game_state.board == ["O", "2", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "previously occupied spaces can not be overwritten" do
      previous_board_state = ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
      move = "1"
      json_game_state = '{"board":["X", "2", "3", "4", "5", "6", "7", "8", "9"] ,"current_player":"O","opponent":null}'

      game_state = Game.play(nil, move, json_game_state)

      assert game_state.board == previous_board_state
    end

    test "current player does not switch until a valid move has been made" do
      json_game_state = '{"board":["X", "2", "3", "4", "5", "6", "7", "8", "9"] ,"current_player":"O","opponent":null}'

      Game.play(nil, "1", json_game_state)
      game_state = Game.play(nil, "2", json_game_state)

      assert game_state.board == ["X", "O", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "an error message is set when an invalid move is attempted" do
      json_game_state = '{"board":["X", "2", "3", "4", "5", "6", "7", "8", "9"] ,"current_player":"O","opponent":null}'
      game_state = Game.play(nil, "1", json_game_state)

      assert game_state.message == "Please select an available space"
    end

    test "error message is removed once a valid move is attempted" do
      json_game_state = '{"board":["X", "2", "3", "4", "5", "6", "7", "8", "9"] ,"current_player":"O","opponent":null}'

      Game.play(nil, "1", json_game_state)
      game_state = Game.play(nil, "2", json_game_state)

      assert game_state.message == nil
    end

    test "playing a turn against a computer opponent will also cause them to take their turn" do
      json_game_state = '{"board":["1", "2", "3", "4", "5", "6", "7", "8", "9"] ,"current_player":"X","opponent":"SimpleComputer"}'

      game_state = Game.play(nil, "1", json_game_state)

      assert length(Board.available_spaces(game_state.board)) == 7
    end
  end

  describe "game over" do
    test "a game is not over if the board has not been filled" do
      move = "1"
      json_game_state = '{"board":["1","2","3","4","5","6","7","8","9"],"current_player":"X","opponent":null}'

      game_state = Game.play(nil, move, json_game_state)

      assert game_state.game_over == false
    end

    test "a game is over if every space is occupied" do
      move = "9"
      json_game_state = '{"board":["X", "O", "X", "O", "X", "O", "X", "O", "9"] ,"current_player":"X","opponent":null}'

      game_state = Game.play(nil, move, json_game_state)

      assert game_state.game_over == true
    end

    test "a game is over if it has been won" do
      move = "3"
      json_game_state = '{"board":["X","X","3","4","5","6","7","8","9"],"current_player":"X","opponent":null}'

      game_state = Game.play(nil, move, json_game_state)

      assert game_state.game_over == true
    end

    test "a game over message is stored once every space is occupied" do
      move = "9"
      json_game_state = '{"board":["X", "O", "X", "O", "X", "O", "X", "O", "9"] ,"current_player":"X","opponent":null}'

      game_state = Game.play(nil, move, json_game_state)

      assert game_state.message == "Game Over!"
    end
  end
end