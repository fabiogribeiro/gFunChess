extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SQ_SIZE = 64

var board = []
var selectedPiece = null

# Called when the node enters the scene tree for the first time.
func _ready():
	board.resize(64)
	board.fill(null)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var brd_index = coordsToSquare(event.position.x, event.position.y)
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
				selectedPiece.position = squareToCoords(selectedPiece.squareNumber)

			selectedPiece.setInSquare()
			selectedPiece.z_index = 0
			selectedPiece = null
			
	if event is InputEventMouseMotion and selectedPiece:
		selectedPiece.position = event.position

func coordsToSquare(x, y):
	return int(y / SQ_SIZE) * 8 + int(x / SQ_SIZE)

func squareToCoords(n):
	return Vector2((n%8)*SQ_SIZE, int(n/8)*SQ_SIZE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
