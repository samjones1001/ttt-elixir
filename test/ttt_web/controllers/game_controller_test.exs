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

  test "GET /game update after POST /game" do
    params = %{move: "1"}
    conn = get(build_conn(), "/")
    |> post("/game", params)
    |> get("/game")

    assert html_response(conn, 200) =~ "<td>X</td>\n         <td>2</td>\n         <td>3</td>\n"
  end

  test "GET /game after POST /game on player 2's turn" do
    conn = get(build_conn(), "/")
           |> post("/game", %{move: "1"})
           |> post("/game", %{move: "2"})
           |> get("/game")

    assert html_response(conn, 200) =~ "<td>X</td>\n         <td>O</td>\n         <td>3</td>\n"
  end

  test "GET /game after POST /game on player 2's turn with an invalid move" do
    conn = get(build_conn(), "/")
           |> post("/game", %{move: "1"})
           |> post("/game", %{move: "1"})
           |> get("/game")

    assert html_response(conn, 200) =~ "<td>X</td>\n         <td>2</td>\n         <td>3</td>\n"
  end
end
