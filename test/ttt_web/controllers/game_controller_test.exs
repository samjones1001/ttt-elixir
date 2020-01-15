defmodule TttWeb.GameControllerTest do
  use TttWeb.ConnCase

  test "GET /game renders correctly" do
    conn = get(build_conn(), "/game")

    assert html_response(conn, 200) =~ "<td>1</td>\n     <td>2</td>\n     <td>3</td>\n"
  end

  test "GET /game update after POST /game updates board" do
    params = %{move: "1", state: '{"board":["1","2","3","4","5","6","7","8","9"],"current_player":"X","opponent":null}'}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "<td>X</td>\n     <td>2</td>\n     <td>3</td>\n"
  end

  test "GET /game updates the board correctly with multiple moves" do
    params = %{move: "2", state: '{"board":["X","2","3","4","5","6","7","8","9"],"current_player":"O","opponent":null}'}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "<td>X</td>\n     <td>O</td>\n     <td>3</td>\n"
  end

  test "GET /game does not update board with an invalid move" do
    params = %{move: "1", state: '{"board":["X","2","3","4","5","6","7","8","9"],"current_player":"O","opponent":null}'}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "<td>X</td>\n     <td>2</td>\n     <td>3</td>\n"
  end

  test "GET /game displays an error message on an invalid move" do
    params = %{move: "1", state: '{"board":["X","2","3","4","5","6","7","8","9"],"current_player":"O","opponent":null}'}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "Please select an available space"
  end

  test "GET /game displays a message at game over" do
    params = %{move: "9", state: '{"board":["X","O","X","O","X","O","X","O","9"],"current_player":"X", "opponent":null}'}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "Game Over"
  end
end
