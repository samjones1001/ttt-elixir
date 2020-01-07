defmodule TttWeb.GameController do
  use TttWeb, :controller

  alias Ttt.Board

  def index(conn, _params) do
    board = get_session(conn, :board)
    render(conn, "index.html", board: board)
  end

  def update(conn, %{"move" => move}) do
    board = Board.create(["1","2","3","4","5","6","7","8","9"], move)
    conn = put_session(conn, :board, board)
    |> redirect(to: "/game")
  end
end