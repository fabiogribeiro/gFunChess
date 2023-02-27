extends "res://scripts/Piece.gd"

var BASE_MOVES = []

func getLegalSquares(board):
	var result = []
	var moves = BASE_MOVES.duplicate()
	if ownColor == PieceColor.WHITE:
		moves.append_array([[-1, -1], [1, -1], [0, -1]])
		if not hasMoved:
			moves.append([0, -2])
	else:
		moves.append_array([[-1, 1], [1, 1], [0, 1]])
		if not hasMoved:
			moves.append([0, 2])
	
	for i in range(2):
		var candidate = getValidSquarePawn(board, moves[i])
		if candidate != null:
			result.append(candidate)

	
	for i in range(2, moves.size()):
		var candidate = getValidSquarePawn(board, moves[i])
		if candidate != null:
			var maybePiece = board[candidate]
			if maybePiece:
				break
			
			result.append(candidate)

	return result

func isCapture(move):
		var length = Vector2(move[0], move[1]).length()
		return length > 1 and length < 2

func getValidSquarePawn(board, move):
	var inBoundsSquare = getValidSquare(move)
	if inBoundsSquare == null: return null

	if isCapture(move):
		# Try en passant
		var maybePiece
		if move[0] > 0:
			# Get piece on the right
			maybePiece = board[squareNumber+1]
		else:
			maybePiece = board[squareNumber-1]
		
		if maybePiece and maybePiece.ownColor != ownColor and maybePiece.is_in_group('pawn'):
			return inBoundsSquare
		
		maybePiece = board[inBoundsSquare]
		if maybePiece and maybePiece.ownColor != ownColor:
			return inBoundsSquare
		
		return null
	else:
		return inBoundsSquare
