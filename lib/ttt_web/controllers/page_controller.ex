defmodule TttWeb.PageController do
  use TttWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
