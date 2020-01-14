defmodule TttWeb.GameController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, params) do
    game = Game.play(Map.get(params, "move"), Map.get(params, "state"))
    render(conn, "index.html", board: Map.get(game, :board), state: Map.get(game, :private_state), game_over: Map.get(game, :game_over), message: Map.get(game, :message))
  end
end