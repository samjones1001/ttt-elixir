defmodule BoardTest do
  use ExUnit.Case

  describe "create" do
    test "create/0 creates an empty board" do
      assert Board.create() == [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end
  end

end