defmodule TttWeb.PageController do
  use TttWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: "/game")
  end
end
