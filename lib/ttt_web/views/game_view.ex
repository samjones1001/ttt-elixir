defmodule TttWeb.GameView do
  use TttWeb, :view

  def render_board(board_state) do
    "<table>
        <tr>
           <td>#{Enum.at(board_state, 0)}</td>
           <td>#{Enum.at(board_state, 1)}</td>
           <td>#{Enum.at(board_state, 2)}</td>
        </tr>
        <tr>
           <td>#{Enum.at(board_state, 3)}</td>
           <td>#{Enum.at(board_state, 4)}</td>
           <td>#{Enum.at(board_state, 5)}</td>
        </tr>
        <tr>
           <td>#{Enum.at(board_state, 6)}</td>
           <td>#{Enum.at(board_state, 7)}</td>
           <td>#{Enum.at(board_state, 8)}</td>
        </tr>
     </table>
    "
  end
end
