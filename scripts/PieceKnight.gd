extends "res://scripts/Piece.gd"

const BASE_MOVES = [
	[-1, 2], [1, 2], [-2, 1], [2, 1], [-2, -1], [2, -1], [-1, -2], [1, -2],
]


func getLegalSquares(board):
	var result = []
	
	for move in BASE_MOVES:
		var candidate = getValidSquare(move)
		if candidate != null:
			var maybePiece = board[candidate]
			if maybePiece and maybePiece.ownColor == ownColor:
				continue
		
			result.append(candidate)
	
	return result
