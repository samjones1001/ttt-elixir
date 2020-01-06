defmodule TttWeb.PageController do
  use TttWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/game")
  end
end
