defmodule TttWeb.GameController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, params) do
    game = Game.play(Map.get(params, "opponent"), Map.get(params, "move"), Map.get(params, "game_id"))
    render(conn, "index.html",
      board: Map.get(game, :board),
      game_id: Map.get(game, :game_id),
      game_over: Map.get(game, :game_over),
      message: Map.get(game, :message)
    )
  end
end