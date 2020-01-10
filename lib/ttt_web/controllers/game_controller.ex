defmodule TttWeb.GameController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, _params) do
    game = get_session(conn, :game)
    board = Game.get_board_state(game)
    message = Game.get_message(game)
    render(conn, "index.html", board: board, message: message)
  end

  def update(conn, %{"move" => move}) do
    Game.play_turn(get_session(conn, :game), move)
    redirect(conn, to: "/game")
  end
end