extends "res://scripts/Piece.gd"

const BASE_MOVES = [
	[1, 1], [0, 1], [-1, 1],
	[-1, 0], [1, 0],
	[-1, -1], [0, -1], [1, -1],
]


func getLegalSquares(board):
	var result = []
	var moves = BASE_MOVES.duplicate()
	if canCastleKingside(board):
		moves.append([2, 0])
	if canCastleQueenside(board):
		moves.append([-2, 0])

	for move in moves:
		var candidate = getValidSquare(move)
		if candidate != null:
			var maybePiece = board[candidate]
			if maybePiece and maybePiece.ownColor == ownColor:
				continue
		
			result.append(candidate)
	
	return result

func canCastleKingside(board):
	if hasMoved: return false

	var rookLocPiece = board[squareNumber + 3]
	return rookLocPiece and \
		(not rookLocPiece.hasMoved) and \
		board[squareNumber + 1] == null and \
		board[squareNumber + 2] == null

func canCastleQueenside(board):
	if hasMoved: return false

	var rookLocPiece = board[squareNumber - 4]
	return rookLocPiece and \
		(not rookLocPiece.hasMoved) and \
		board[squareNumber - 1] == null and \
		board[squareNumber - 2] == null and \
		board[squareNumber - 3] == null
