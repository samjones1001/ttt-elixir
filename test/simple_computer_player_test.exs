defmodule SimpleComputerPlayerTest do
  use ExUnit.Case

  alias Ttt.SimpleComputerPlayer

  describe "select_move" do
    test "selects a random space from those available" do
      available_spaces = ["1", "2", "3"]
      assert Enum.member?(available_spaces, SimpleComputerPlayer.select_move(available_spaces)) == true
    end
  end
end