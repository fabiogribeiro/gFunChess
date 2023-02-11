extends "res://Piece.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const BASE_MOVES = [
	-7, -14, -21, -28, -35, -49, -56, 	# Northeast
	7, 14, 21, 28, 35, 49, 56, 			# Southwest
	-9, -18, -27, -36, -45, -54, -63,	# Northwest
	9, 18, 27, 36, 45, 54, 63			# Southeast
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Returns a list of indexes the legal squares
func getLegalSquares(board):
	var result = []
	var diagonal = 4

	while (diagonal):
		for i in range(7):
			var candidate = squareNumber + BASE_MOVES[7*(diagonal-1) + i]
			if candidate >= 0 and candidate < 64:
				var maybePiece = board[candidate]
				if maybePiece:
					if maybePiece.ownColor != ownColor:
						result.append(candidate)
						break
					else: break
				else:
					result.append(candidate)
					
		diagonal -= 1

	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
