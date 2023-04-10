extends Node2D

const PieceWhiteQueen = preload("res://scenes/pieces/PieceWhiteQueen.tscn")
const PieceBlackQueen = preload("res://scenes/pieces/PieceBlackQueen.tscn")
const PieceWhiteRook = preload("res://scenes/pieces/PieceWhiteRook.tscn")
const PieceBlackRook = preload("res://scenes/pieces/PieceBlackRook.tscn")
const PieceWhiteBishop = preload("res://scenes/pieces/PieceWhiteBishop.tscn")
const PieceBlackBishop = preload("res://scenes/pieces/PieceBlackBishop.tscn")
const PieceWhiteKnight = preload("res://scenes/pieces/PieceWhiteKnight.tscn")
const PieceBlackKnight = preload("res://scenes/pieces/PieceBlackKnight.tscn")

var pieceColor = 0
var selectedPiece = null
var queen
var rook
var bishop
var knight

signal selected(piece)

func init(color):
	pieceColor = color

	if pieceColor == 0:
		queen = PieceWhiteQueen.instantiate()
		queen.ownColor = 0
		queen.position = $QueenArea.position
		add_child(queen)

		rook = PieceWhiteRook.instantiate()
		rook.ownColor = 0
		rook.position = $RookArea.position
		add_child(rook)

		bishop = PieceWhiteBishop.instantiate()
		bishop.ownColor = 0
		bishop.position = $BishopArea.position
		add_child(bishop)

		knight = PieceWhiteKnight.instantiate()
		knight.ownColor = 0
		knight.position = $KnightArea.position
		add_child(knight)
	else:
		queen = PieceBlackQueen.instantiate()
		queen.ownColor = 1
		queen.position = $QueenArea.position
		add_child(queen)

		rook = PieceBlackRook.instantiate()
		rook.ownColor = 1
		rook.position = $RookArea.position
		add_child(rook)

		bishop = PieceBlackBishop.instantiate()
		bishop.ownColor = 1
		bishop.position = $BishopArea.position
		add_child(bishop)

		knight = PieceBlackKnight.instantiate()
		knight.ownColor = 1
		knight.position = $KnightArea.position
		add_child(knight)

func _on_QueenArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("selected", queen)


func _on_RookArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("selected", rook)


func _on_BishopArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("selected", bishop)


func _on_KnightArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("selected", knight)
