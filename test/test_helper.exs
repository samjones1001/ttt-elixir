ExUnit.start()

defmodule Helpers do
  alias Ttt.GameStore

  def start_game(board, player_1, player_2) do
    GameStore.start(%{board: board, current_player: player_1, next_player: player_2})
  end
end