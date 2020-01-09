defmodule TttWeb.GameController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, _params) do
    game = get_session(conn, :game)
    board = Game.get_board_state(game)
    error = Game.get_error_message(game)
    render(conn, "index.html", board: board, error: error)
  end

  def update(conn, %{"move" => move}) do
    Game.play_turn(get_session(conn, :game), move)
    redirect(conn, to: "/game")
  end
end