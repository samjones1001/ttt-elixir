defmodule TttWeb.GameControllerTest do
  use TttWeb.ConnCase

  test "POST /game" do
    params = %{move: "5"}
    conn = get(build_conn(), "/")
    |> post("/game", params)

    assert html_response(conn, 302) =~  "redirected"
  end

  test "GET /game" do
    conn = get(build_conn(), "/")
    |> get("/game")

    assert html_response(conn, 200) =~ "<td>1</td>\n         <td>2</td>\n         <td>3</td>\n"
  end

  test "page update after POST /game" do
    params = %{move: "1"}
    conn = get(build_conn(), "/")
    |> post("/game", params)
    |> get("/game")

    assert html_response(conn, 200) =~ "<td>X</td>\n         <td>2</td>\n         <td>3</td>\n"
  end
end
