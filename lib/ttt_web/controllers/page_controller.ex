defmodule TttWeb.PageController do
  use TttWeb, :controller

  alias Ttt.Game

  def index(conn, _params) do
    conn
    |> redirect(to: "/game")
  end
end
