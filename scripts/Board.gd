extends Node

const SQ_SIZE = 64
const FLIP_TRANSFORM = Transform2D(Vector2(-1, 0), Vector2(0, -1), Vector2(512, 512))
const PieceWhiteQueen = preload("res://scenes/pieces/PieceWhiteQueen.tscn")
const PieceBlackQueen = preload("res://scenes/pieces/PieceBlackQueen.tscn")


var flipped = false
var transform = Transform2D.IDENTITY
var board = []

var selectedPiece = null
var lastMove = null
var enPassant = false
var castlingKingside = false
var castlingQueenside = false
var inCheck = false

var showLegalMoves = false

var turn = 0

signal mate(winner)

func _ready():
	board.resize(64)
	board.fill(null)
	
	initPieces()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		event.position = transform * event.position

		var brd_index = Utils.coordsToSquare(event.position.x, event.position.y)
		var pieceUnder = board[brd_index]

		if (not selectedPiece) and pieceUnder:
			selectedPiece = pieceUnder
			selectedPiece.z_index = 1
			board[brd_index] = null

			if showLegalMoves: showLegalMoves()
	
		if selectedPiece and not event.pressed:
			get_tree().call_group('circle', 'queue_free')

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
				handlePromotion()
				turn = not selectedPiece.ownColor

				if castlingKingside:
					var rook = board[brd_index+1]
					rook.squareNumber = brd_index - 1
					board[brd_index-1] = rook
					if flipped: rook.position += Vector2(2*SQ_SIZE, 0)
					else: rook.position -= Vector2(2*SQ_SIZE, 0)
					board[brd_index+1] = null
					castlingKingside = false
				if castlingQueenside:
					var rook = board[brd_index-2]
					rook.squareNumber = brd_index + 1
					board[brd_index+1] = rook
					if flipped: rook.position -= Vector2(3*SQ_SIZE, 0)
					else: rook.position += Vector2(3*SQ_SIZE, 0)
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

				flipBoard()
				putInCheck()
			else:
				board[selectedPiece.squareNumber] = selectedPiece
				selectedPiece.position = transform * Utils.squareToCoords(selectedPiece.squareNumber)

			selectedPiece.setInSquare()
			selectedPiece.z_index = 0
			selectedPiece = null
			
			if not hasMoves():
				if inCheck: emit_signal("mate", lastMove[0].ownColor)
				else: emit_signal("mate", null)

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
func isLegal(piece, square, modify=true):
	if piece.is_in_group('king'):
		if square - piece.squareNumber == 2:
			# We're castling kingside
			var kingSafe = isKingSafe(piece, square) and \
				isKingSafe(piece, square - 1) and \
				isKingSafe(piece, square - 2)
			if kingSafe:
				if modify: castlingKingside = true
				return true

		elif square - piece.squareNumber == -2:
			# We're castling queenside
			var kingSafe = isKingSafe(piece, square) and \
				isKingSafe(piece, square + 1) and \
				isKingSafe(piece, square + 2) and \
				isKingSafe(piece, square + 3)

			if kingSafe:
				if modify: castlingQueenside = true
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
			if modify: enPassant = true
			return true

	else:
		return isKingSafe(piece, square)

func initPieces():
	for piece in get_tree().get_nodes_in_group('piece'):
		piece.boardInit(board)

func showLegalMoves():
	for i in range(64):
		if selectedPiece.ownColor == int(turn) and \
			isMove(selectedPiece, i) and \
			isLegal(selectedPiece, i, false):
				var newCircle = $Circle.duplicate()
				newCircle.add_to_group('circle')
				newCircle.position = transform * Utils.squareToCoords(i)
				add_child(newCircle)

func hasMoves():
	var tmp = selectedPiece
	for piece in board:
		if piece:
			selectedPiece = piece
			for i in range(64):
				if selectedPiece.ownColor == int(turn) and \
					isMove(selectedPiece, i) and \
					isLegal(selectedPiece, i, false):
						selectedPiece = tmp
						return true

	selectedPiece = tmp
	return false

func putInCheck():
	var squares = []
	var tmp = selectedPiece
	for piece in board:
		if piece:
			selectedPiece = piece
			for i in range(64):
				if selectedPiece.ownColor != int(turn) and \
					isMove(selectedPiece, i) and \
					isLegal(selectedPiece, i, false):
						squares.append(i)

	selectedPiece = tmp
	
	var king = $WKing
	if king.ownColor != int(turn):
		king = $BKing
	
	if squares.has(king.squareNumber):
		$CheckSquare.position = king.position
		$CheckSquare.show()
		inCheck = true
	else:
		$CheckSquare.hide()
		inCheck = false

func flipBoard():
	var pieces = get_tree().get_nodes_in_group('piece')
	for piece in pieces:
		piece.position = FLIP_TRANSFORM * piece.position

	if flipped:
		transform = Transform2D.IDENTITY
	else:
		transform = FLIP_TRANSFORM

	flipped = not flipped

func handlePromotion():
	var piece = lastMove[0]
	var square = lastMove[2]
	var new_piece = null
	if piece.is_in_group('pawn'):
		if square / 8 == 0 and piece.ownColor == 0 :
			new_piece = PieceWhiteQueen.instance()

		if square / 8 == 7 and piece.ownColor == 1:
			new_piece = PieceBlackQueen.instance()

	if new_piece:
			new_piece.add_to_group('piece')
			self.add_child(new_piece)
			new_piece.squareNumber = square
			board[square] = new_piece
			new_piece.position = transform * Utils.squareToCoords(square)
			piece.queue_free()
