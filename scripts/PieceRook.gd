extends "res://scripts/Piece.gd"

const BASE_MOVES = [
		-1, -2, -3, -4, -5, -6, -7,				# Left
		1, 2, 3, 4, 5, 6, 7,					# Right
		-8, -16, -24, -32, -40, -48, -56,		# Up
		8, 16, 24, 32, 40, 48, 56				# Down 
	]

func getLegalSquares(board):
	var result = []
	var line = 4

	while (line):
		for i in range(7):
			var move = BASE_MOVES[7*(line-1) + i]
			var candidate = squareNumber + move

			if abs(move) < 8 and squareNumber/8 != candidate/8:
				continue
			
			if candidate >= 0 and candidate < 64:
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
