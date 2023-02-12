extends "res://scripts/Piece.gd"

var BASE_MOVES = []
var hasMoved = false

func getLegalSquares(board):
	var result = []
	var moves = BASE_MOVES.duplicate()
	if ownColor == PieceColor.WHITE:
		moves.append([0, -1])
		if not hasMoved:
			moves.append([0, -2])
	else:
		moves.append([0, 1])
		if not hasMoved:
			moves.append([0, 2])
	
	for move in moves:
		var candidate = getValidSquare(move)
		if candidate != null:
			var maybePiece = board[candidate]
			if maybePiece:
				if maybePiece.ownColor == ownColor:
					break
				else:
					result.append(candidate)
					break
			
			result.append(candidate)
	
	return result
