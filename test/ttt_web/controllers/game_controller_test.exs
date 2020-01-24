defmodule TttWeb.GameControllerTest do
  use TttWeb.ConnCase
  import Helpers

  test "GET /game renders correctly" do
    params = %{current_player_type: "Human", next_player_type: "Human"}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "<td onClick=\"Ttt.registerClick(1, )\">1</td>\n     <td onClick=\"Ttt.registerClick(2, )\">2</td>\n     <td onClick=\"Ttt.registerClick(3, )\">3</td>"
  end

  test "GET /game update after playing a turn" do
    game_id = start_game(["1","2","3","4","5","6","7","8","9"], %{type: "Human", marker: "X"}, %{type: "Human", marker: "O"})
    game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
    params = %{move: "1", game_id: game_id_string, current_player_type: "Human"}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ " <td onClick=\"Ttt.registerClick(1, false)\">X</td>\n     <td onClick=\"Ttt.registerClick(2, false)\">2</td>\n     <td onClick=\"Ttt.registerClick(3, false)\">3</td>"
  end

  test "GET /game updates the board correctly with multiple moves" do
    game_id = start_game(["X","2","3","4","5","6","7","8","9"], %{type: "Human", marker: "O"}, %{type: "Human", marker: "X"})
    game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
    params = %{move: "2", game_id: game_id_string, current_player_type: "Human"}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "<td onClick=\"Ttt.registerClick(1, false)\">X</td>\n     <td onClick=\"Ttt.registerClick(2, false)\">O</td>\n     <td onClick=\"Ttt.registerClick(3, false)\">3</td>"
  end

  test "GET /game does not update board with an invalid move" do
    game_id = start_game(["X","2","3","4","5","6","7","8","9"], %{type: "Human", marker: "O"}, %{type: "Human", marker: "X"})
    game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
    params = %{move: "1", game_id: game_id_string, current_player_type: "Human"}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ " <td onClick=\"Ttt.registerClick(1, )\">X</td>\n     <td onClick=\"Ttt.registerClick(2, )\">2</td>\n     <td onClick=\"Ttt.registerClick(3, )\">3</td>"
  end

  test "GET /game displays an error message on an invalid move" do
    game_id = start_game(["X","2","3","4","5","6","7","8","9"], %{type: "Human", marker: "O"}, %{type: "Human", marker: "X"})
    game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
    params = %{move: "1", game_id: game_id_string, current_player_type: "Human"}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "Please select an available space"
  end

  test "GET /game displays a turn end message on a valid move" do
    game_id = start_game(["X","2","3","4","5","6","7","8","9"], %{type: "Human", marker: "O"}, %{type: "Human", marker: "X"})
    game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
    params = %{move: "2", game_id: game_id_string, current_player_type: "Human"}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "O took space 2"
  end

  test "GET /game displays a message at game over" do
    game_id = start_game(["X","O","X","O","X","O","X","O","9"], %{type: "Human", marker: "X"}, %{type: "Human", marker: "O"})
    game_id_string = String.slice(inspect(:erlang.pid_to_list(elem(game_id, 1))), 2..-3)
    params = %{move: "9", game_id: game_id_string, current_player_type: "Human"}
    conn = get(build_conn(), "/game", params)

    assert html_response(conn, 200) =~ "Game Over"
  end
end
