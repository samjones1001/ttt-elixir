defmodule TttWeb.GameControllerTest do
  use TttWeb.ConnCase

  test "POST /game redirects" do
    params = %{move: "5"}
    conn = get(build_conn(), "/")
    |> post("/game", params)

    assert html_response(conn, 302) =~  "redirected"
  end

  test "GET /game renders correctly" do
    conn = get(build_conn(), "/")
    |> get("/game")

    assert html_response(conn, 200) =~ "<td>1</td>\n     <td>2</td>\n     <td>3</td>\n"
  end

  test "GET /game update after POST /game updates board" do
    params = %{move: "1"}
    conn = get(build_conn(), "/")
    |> post("/game", params)
    |> get("/game")

    assert html_response(conn, 200) =~ "<td>X</td>\n     <td>2</td>\n     <td>3</td>\n"
  end

  test "GET /game after POST /game on player 2's turn updates board with both moves" do
    conn = get(build_conn(), "/")
    |> post("/game", %{move: "1"})
    |> post("/game", %{move: "2"})
    |> get("/game")

    assert html_response(conn, 200) =~ "<td>X</td>\n     <td>O</td>\n     <td>3</td>\n"
  end

  test "GET /game after POST /game on player 2's turn does not update board with an invalid move" do
    conn = get(build_conn(), "/")
    |> post("/game", %{move: "1"})
    |> post("/game", %{move: "1"})
    |> get("/game")

    assert html_response(conn, 200) =~ "<td>X</td>\n     <td>2</td>\n     <td>3</td>\n"
  end

  test "GET /game after POST /game on player 2's turn displays an error message" do
    conn = get(build_conn(), "/")
    |> post("/game", %{move: "1"})
    |> post("/game", %{move: "1"})
    |> get("/game")

    assert html_response(conn, 200) =~ "Please select an available move"
  end

  test "GET /game displays a message at game over" do
    conn = get(build_conn(), "/")
    |> post("/game", %{move: "1"})
    |> post("/game", %{move: "2"})
    |> post("/game", %{move: "3"})
    |> post("/game", %{move: "4"})
    |> post("/game", %{move: "5"})
    |> post("/game", %{move: "6"})
    |> post("/game", %{move: "7"})
    |> post("/game", %{move: "8"})
    |> post("/game", %{move: "9"})
    |> get("/game")

    assert html_response(conn, 200) =~ "Game Over!"
  end
end
