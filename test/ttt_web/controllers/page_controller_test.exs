defmodule TttWeb.PageControllerTest do
  use TttWeb.ConnCase

  test "GET / renders the homepage" do
    conn = get(build_conn(), "/")
    assert html_response(conn, 200) =~  "What kind of game would you like to play?"
  end
end
