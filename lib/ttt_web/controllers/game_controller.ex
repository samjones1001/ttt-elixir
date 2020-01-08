defmodule TttWeb.GameController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, _params) do
    board = Game.get_board_state(get_session(conn, :game))
    render(conn, "index.html", board: board)
  end

  def update(conn, %{"move" => move}) do
    Game.play_turn(get_session(conn, :game), move)
    redirect(conn, to: "/game")
  end
end