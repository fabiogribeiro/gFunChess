extends "res://scripts/Piece.gd"

const BASE_MOVES = [
		[1, 1],[2, 2],[3, 3],[4, 4],[5, 5],[6,6],[7,7],
		[-1, -1],[-2, -2],[-3, -3],[-4, -4],[-5, -5],[-6,-6],[-7,-7],
		[1, -1],[2, -2],[3, -3],[4, -4],[5, -5],[6,-6],[7,-7],
		[-1, 1],[-2, 2],[-3, 3],[-4, 4],[-5, 5],[-6,6],[-7,7],
		[-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
		[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
		[0, 1], [0, 2], [0, 3],[0, 4],[0, 5],[0, 6],[0, 7],
		[0, -1],[0, -2],[0, -3],[0, -4],[0, -5],[0, -6],[0, -7],
	]
	
func getLegalSquares(board):
	var result = []
	var line = 8

	while (line):
		for i in range(7):
			var move = BASE_MOVES[7*(line-1) + i]
			var candidate = getValidSquare(move)
			
			if candidate != null:
				var maybePiece = board[candidate]
				if maybePiece:
					if maybePiece.ownColor != ownColor:
						result.append(candidate)
						break
					else: break
				else:
					result.append(candidate)
					
		line -= 1

	return result
