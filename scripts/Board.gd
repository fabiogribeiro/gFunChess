extends Node

const SQ_SIZE = 64

var board = []
var selectedPiece = null
var lastMove = null
var enPassant = false
var castlingKingside = false
var castlingQueenside = false

var turn = 0

func _ready():
	board.resize(64)
	board.fill(null)
	
	initPieces()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var brd_index = Utils.coordsToSquare(event.position.x, event.position.y)
		var pieceUnder = board[brd_index]

		if (not selectedPiece) and pieceUnder:
			selectedPiece = pieceUnder
			selectedPiece.z_index = 1
			board[brd_index] = null
	
		if selectedPiece and not event.pressed:
			if selectedPiece.ownColor == int(turn) and \
				isMove(selectedPiece, brd_index) and \
				isLegal(selectedPiece, brd_index):
				if board[brd_index]:
					board[brd_index].queue_free()
					board[brd_index] = null
				
				lastMove = [selectedPiece, selectedPiece.squareNumber, brd_index]
				board[brd_index] = selectedPiece
				selectedPiece.squareNumber = brd_index
				selectedPiece.hasMoved = true
				turn = not selectedPiece.ownColor

				if castlingKingside:
					var rook = board[brd_index+1]
					rook.squareNumber = brd_index - 1
					board[brd_index-1] = rook
					rook.position -= Vector2(2*SQ_SIZE, 0)
					board[brd_index+1] = null
					castlingKingside = false
				if castlingQueenside:
					var rook = board[brd_index-2]
					rook.squareNumber = brd_index + 1
					board[brd_index+1] = rook
					rook.position += Vector2(3*SQ_SIZE, 0)
					board[brd_index-2] = null
					castlingQueenside = false
				if enPassant:
					if lastMove[2] - lastMove[1] < 0:
						board[brd_index + 8].queue_free()
						board[brd_index + 8] = null
					else:
						board[brd_index - 8].queue_free()
						board[brd_index - 8] = null
					enPassant = false
				
			else:
				board[selectedPiece.squareNumber] = selectedPiece
				selectedPiece.position = Utils.squareToCoords(selectedPiece.squareNumber)

			selectedPiece.setInSquare()
			selectedPiece.z_index = 0
			selectedPiece = null
			
	if event is InputEventMouseMotion and selectedPiece:
		selectedPiece.position = event.position

func isMove(piece, square):
	return selectedPiece.getLegalSquares(board).has(square)

# Check for king safety
func isKingSafe(piece, square):
	var test_board = board.duplicate()
	test_board[piece.squareNumber] = null
	test_board[square] = piece

	var king = $WKing;
	if king.ownColor != piece.ownColor:
		king = $BKing

	var squares = []
	for test_piece in test_board:
		if test_piece:
			if test_piece.ownColor != piece.ownColor:
				squares.append_array(test_piece.getLegalSquares(test_board))

	if piece.is_in_group('king'):
		return not squares.has(square)
	
	return not squares.has(king.squareNumber)

# Check for en passant and castling
func isLegal(piece, square):
	if piece.is_in_group('king'):
		if square - piece.squareNumber == 2:
			# We're castling kingside
			var kingSafe = isKingSafe(piece, square) and \
				isKingSafe(piece, square - 1) and \
				isKingSafe(piece, square - 2)
			if kingSafe:
				castlingKingside = true
				return true

		elif square - piece.squareNumber == -2:
			# We're castling queenside
			var kingSafe = isKingSafe(piece, square) and \
				isKingSafe(piece, square + 1) and \
				isKingSafe(piece, square + 2) and \
				isKingSafe(piece, square + 3)

			if kingSafe:
				castlingQueenside = true
				return true
		else:
			return isKingSafe(piece, square)
	elif piece.is_in_group('pawn'):
		if (square - piece.squareNumber) % 8 == 0 or board[square]:
			return isKingSafe(piece, square)

		# Try en passant
		var enemyPawn
		if piece.squareNumber > square:
			enemyPawn = board[square + 8]
		else:
			enemyPawn = board[square - 8]
		if not lastMove or lastMove[0] != enemyPawn or abs(lastMove[1] - enemyPawn.squareNumber) <= 8:
			return false
		
		var test_board = board.duplicate()
		var tmp = board
		test_board[enemyPawn.squareNumber] = null
		board = test_board
		
		var kingSafe = isKingSafe(piece, square)
		board = tmp
		
		if kingSafe:
			enPassant = true
			return true

	else:
		return isKingSafe(piece, square)

func initPieces():
	for piece in get_tree().get_nodes_in_group('piece'):
		piece.boardInit(board)
