defmodule TttWeb.GameControllerTest do
  use TttWeb.ConnCase

  test "POST /game", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~  "redirected"
  end
end
