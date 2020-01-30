import css from "../css/app.css"
import "phoenix_html"

window.Ttt = (function() {
  const lineVectors = new Map()
  lineVectors.set("0,4,8", "M6 6 L160 158")
  lineVectors.set("0,1,2", "M6 28 L165 28")
  lineVectors.set("3,4,5", "M6 84 L165 84")
  lineVectors.set("6,7,8", "M6 140 L165 140")
  lineVectors.set("0,3,6", "M29 6 L29 162")
  lineVectors.set("1,4,7", "M85 6 L85 162")
  lineVectors.set("2,5,8", "M141 6 L141 162")
  lineVectors.set("2,4,6", "M161 8 L7 160")

  let registerClick = function(selectedSquare, gameOver) {
    if (!gameOver) {
      document.getElementById('move_input').value = selectedSquare
      submitForm()
    }
  }

  let submitForm = function() {
    document.getElementById("play_turn_form").submit()
  }

  let drawLine = function(winningIndices) {
    if (winningIndices != null) {
      setLineVectors(lineVectors.get(winningIndices))
      document.getElementById("svgLine").style.display = "block"
    }
  }

  let setLineVectors = function(vectors) {
    let line = document.getElementById("line")
    line.setAttribute("d", vectors)
  }

  return {
    registerClick,
    submitForm,
    drawLine
  }
})();


