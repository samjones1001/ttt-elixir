defmodule TttWeb.GameController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, params) do
    game = Game.play(Map.get(params, "player_type"), Map.get(params, "move"), game_id_to_pid(Map.get(params, "game_id")))
    render(conn, "index.html",
      board: Map.get(game, :board),
      game_id: game_id_to_string(Map.get(game, :game_id)),
      game_over: Map.get(game, :game_over),
      message: Map.get(game, :message),
      player_type: Map.get(game, :player_type)
    )
  end

  defp game_id_to_string(game_id) do
    String.slice(inspect(:erlang.pid_to_list(game_id)), 2..-3)
  end

  def game_id_to_pid(_game_id_string = nil) do
    nil
  end

  def game_id_to_pid(game_id_string) do
    :erlang.list_to_pid('<#{game_id_string}>')
  end
end