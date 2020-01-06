defmodule TttWeb.GameControllerTest do
  use TttWeb.ConnCase

  test "POST /game" do
    params = %{move: "5"}
    conn = post(build_conn(), "/game", params)
    assert html_response(conn, 302) =~  "redirected"
  end

  test "GET /game", %{conn: conn} do
    conn = get(conn, "/game")
    assert html_response(conn, 200) =~ "form"
  end
end
