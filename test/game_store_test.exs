defmodule GameStoreTest do
  use ExUnit.Case

  alias Ttt.GameStore

  setup do
    initial_state = %{board: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"], current_player: "X", opponent: nil}
    {:ok, game_store} = GameStore.start(initial_state)
    %{game_store: game_store}
  end

  test "retrieves the stored state", %{game_store: game_store} do
    initial_state = %{board: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"], current_player: "X", opponent: nil}
    assert GameStore.retrieve(game_store) == initial_state
  end

  test "updates the stores state", %{game_store: game_store} do
    updated_state = %{board: ["X", "2", "3", "4", "5", "6", "7", "8", "9", "10"], current_player: "O", opponent: nil}
    GameStore.update(game_store, updated_state)
    assert GameStore.retrieve(game_store) == updated_state
  end
end