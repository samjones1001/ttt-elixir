defmodule Ttt.SimpleComputerPlayer do
  def select_move(available_spaces) do
    Enum.random(available_spaces)
  end
end

