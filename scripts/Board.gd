extends Node

const SQ_SIZE = 64

var board = []
var selectedPiece = null
var lastMove = null

func _ready():
	board.resize(64)
	board.fill(null)

	board[0] = $BKing
	$BKing.squareNumber = 0

	board[2] = $WKing
	$WKing.squareNumber = 2
	
	board[1] = $BQ
	$BQ.squareNumber = 1
	
	board[12] = $BPawn
	$BPawn.squareNumber = 12
	
	board[29] = $WPawn
	$WPawn.squareNumber = 29

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var brd_index = Utils.coordsToSquare(event.position.x, event.position.y)
		var pieceUnder = board[brd_index]

		if (not selectedPiece) and pieceUnder:
			selectedPiece = pieceUnder
			selectedPiece.z_index = 1
			board[brd_index] = null
	
		if selectedPiece and not event.pressed:
			if isMove(selectedPiece, brd_index) and isLegal(selectedPiece, brd_index):
				if board[brd_index]:
					board[brd_index].queue_free()
				
				lastMove = [selectedPiece, selectedPiece.squareNumber]
				board[brd_index] = selectedPiece
				selectedPiece.squareNumber = brd_index
				selectedPiece.hasMoved = true
				
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
		pass
	elif piece.is_in_group('pawn'):
		# Remove would be capture off board temporaril
		if (square - piece.squareNumber) % 8 == 0:
			return isKingSafe(piece, square)

		# En passant
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
		
		return kingSafe
		
	else:
		return isKingSafe(piece, square)
