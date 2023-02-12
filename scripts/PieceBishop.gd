extends "res://scripts/Piece.gd"

const BASE_MOVES = [
		[1, 1],[2, 2],[3, 3],[4, 4],[5, 5],[6,6],[7,7],
		[-1, -1],[-2, -2],[-3, -3],[-4, -4],[-5, -5],[-6,-6],[-7,-7],
		[1, -1],[2, -2],[3, -3],[4, -4],[5, -5],[6,-6],[7,-7],
		[-1, 1],[-2, 2],[-3, 3],[-4, 4],[-5, 5],[-6,6],[-7,7],
	]

func getLegalSquares(board):
	var result = []
	var diagonal = 4

	while (diagonal):
		for i in range(7):
			var move = BASE_MOVES[7*(diagonal-1) + i]
			var validSquare = getValidSquare(move)
			if validSquare != null:
				var maybePiece = board[validSquare]
				if maybePiece:
					if maybePiece.ownColor != ownColor:
						result.append(validSquare)
						break
					else: break
				else:
					result.append(validSquare)
					
		diagonal -= 1

	return result
