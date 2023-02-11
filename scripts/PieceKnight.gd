extends "res://scripts/Piece.gd"

const BASE_MOVES = [-17, 17, -15, 15, -10, 10, -6, 6]

func getLegalSquares(board):
	var result = []
	
	for move in BASE_MOVES:
		var candidate = squareNumber + move
		if candidate >= 0 and candidate < 64:
			var maybePiece = board[candidate]
			if maybePiece and maybePiece.ownColor == ownColor:
				continue
		
			result.append(candidate)
	
	return result
