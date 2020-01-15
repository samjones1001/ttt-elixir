defmodule GameTest do
  use ExUnit.Case

  alias Ttt.Game
  alias Ttt.GameStore
  alias Ttt.Board

  describe "play" do
    test "creates a new game if passed no arguments" do
      game_state = Game.play(nil,nil, nil)
      assert game_state.board == ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "updates the board if provided arguments" do
      game_id = GameStore.start(%{board: ["1","2","3","4","5","6","7","8","9"],opponent: nil, current_player: "X"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
      move = "1"

      game_state = Game.play(nil, move, game_id_string)

      assert game_state.board == ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "places the correct marker dependent on current_player in the passed state" do
      game_id = GameStore.start(%{board: ["1","2","3","4","5","6","7","8","9"],opponent: nil, current_player: "O"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
      move = "1"

      game_state = Game.play(nil, move, game_id_string)

      assert game_state.board == ["O", "2", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "previously occupied spaces can not be overwritten" do
      previous_board_state = ["X", "2", "3", "4", "5", "6", "7", "8", "9"]
      game_id = GameStore.start(%{board: ["X","2","3","4","5","6","7","8","9"],opponent: nil, current_player: "O"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
      move = "1"

      game_state = Game.play(nil, move, game_id_string)

      assert game_state.board == previous_board_state
    end

    test "current player does not switch until a valid move has been made" do
      game_id = GameStore.start(%{board: ["X","2","3","4","5","6","7","8","9"],opponent: nil, current_player: "O"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      Game.play(nil, "1", game_id_string)
      game_state = Game.play(nil, "2", game_id_string)

      assert game_state.board == ["X", "O", "3", "4", "5", "6", "7", "8", "9"]
    end

    test "an error message is set when an invalid move is attempted" do
      game_id = GameStore.start(%{board: ["X","2","3","4","5","6","7","8","9"],opponent: nil, current_player: "O"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      game_state = Game.play(nil, "1", game_id_string)

      assert game_state.message == "Please select an available space"
    end

    test "error message is removed once a valid move is attempted" do
      game_id = GameStore.start(%{board: ["X","2","3","4","5","6","7","8","9"],opponent: nil, current_player: "O"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      Game.play(nil, "1", game_id_string)
      game_state = Game.play(nil, "2", game_id_string)

      assert game_state.message == nil
    end

    test "playing a turn against a computer opponent will also cause them to take their turn" do
      game_id = GameStore.start(%{board: ["X","2","3","4","5","6","7","8","9"],opponent: "SimpleComputer", current_player: "O"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      game_state = Game.play(nil, "1", game_id_string)

      assert length(Board.available_spaces(game_state.board)) == 7
    end
  end

  describe "game over" do
    test "a game is not over if the board has not been filled" do
      game_id = GameStore.start(%{board: ["1","2","3","4","5","6","7","8","9"],opponent: nil, current_player: "X"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      game_state = Game.play(nil, "1", game_id_string)

      assert game_state.game_over == false
    end

    test "a game is over if every space is occupied" do
      game_id = GameStore.start(%{board: ["X","O","X","O","X","O","X","O","9"],opponent: nil, current_player: "X"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      game_state = Game.play(nil, "9", game_id_string)

      assert game_state.game_over == true
    end

    test "a game is over if it has been won" do
      game_id = GameStore.start(%{board: ["X","X","3","4","5","6","7","8","9"],opponent: nil, current_player: "X"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      game_state = Game.play(nil, "3", game_id_string)

      assert game_state.game_over == true
    end

    test "a game over message is stored once the game is over" do
      game_id = GameStore.start(%{board: ["X","X","3","4","5","6","7","8","9"],opponent: nil, current_player: "X"})
      game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)

      game_state = Game.play(nil, "3", game_id_string)

      assert game_state.message == "Game Over!"
    end
  end
end