defmodule TttWeb.GameController do
  use TttWeb, :controller

  def index(conn, _params) do
    move = get_session(conn, :move)
    render(conn, "index.html", move: move)
  end

  def update(conn, %{"move" => move}) do
    conn = put_session(conn, :move, move)
    redirect(conn, to: "/game")
  end
end