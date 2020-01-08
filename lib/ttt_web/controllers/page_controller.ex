defmodule TttWeb.PageController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, _params) do
    {:ok, game} = Game.start()
    conn
    |> put_session(:game, game)
    |> redirect(to: "/game")
  end
end
