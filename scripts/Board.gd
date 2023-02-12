extends Node

const SQ_SIZE = 64

var board = []
var selectedPiece = null

func _ready():
	board.resize(64)
	board.fill(null)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var brd_index = Utils.coordsToSquare(event.position.x, event.position.y)
		var pieceUnder = board[brd_index]

		if (not selectedPiece) and pieceUnder:
			selectedPiece = pieceUnder
			selectedPiece.z_index = 1
			board[brd_index] = null
	
		if selectedPiece and not event.pressed:
			var isLegal = selectedPiece.getLegalSquares(board).has(brd_index)
			if isLegal:
				if board[brd_index]:
					board[brd_index].queue_free()
				board[brd_index] = selectedPiece
				selectedPiece.squareNumber = brd_index
			else:
				board[selectedPiece.squareNumber] = selectedPiece
				selectedPiece.position = Utils.squareToCoords(selectedPiece.squareNumber)

			selectedPiece.setInSquare()
			selectedPiece.z_index = 0
			selectedPiece = null
			
	if event is InputEventMouseMotion and selectedPiece:
		selectedPiece.position = event.position
