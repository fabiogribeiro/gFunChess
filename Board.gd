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
	board[0] = $WhiteBishop

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var index_x = int(event.position.x / SQ_SIZE)
		var index_y = int(event.position.y / SQ_SIZE)
		
		var arr_index = index_y * 8 + index_x
		var pieceUnder = board[arr_index]

		if (not selectedPiece) and pieceUnder:
			selectedPiece = pieceUnder
			board[arr_index] = null
	
		if selectedPiece and not event.pressed:
			selectedPiece.setInSquare()
			board[arr_index] = selectedPiece
			selectedPiece = null
	
	if event is InputEventMouseMotion and selectedPiece:
		selectedPiece.position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
