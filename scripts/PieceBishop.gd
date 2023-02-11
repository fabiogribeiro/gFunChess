extends "res://scripts/Piece.gd"

const BASE_MOVES = [
	-7, -14, -21, -28, -35, -49, -56, 	# Northeast
	7, 14, 21, 28, 35, 49, 56, 			# Southwest
	-9, -18, -27, -36, -45, -54, -63,	# Northwest
	9, 18, 27, 36, 45, 54, 63			# Southeast
]

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
