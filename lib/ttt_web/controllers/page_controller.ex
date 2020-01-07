defmodule TttWeb.PageController do
  use TttWeb, :controller

  def index(conn, _params) do
    conn
    |> clear_session
    |> redirect(to: "/game")
  end
end
