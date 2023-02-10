extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum PieceColor {WHITE, BLACK}
const SQ_SIZE = 64

func setInSquare():
	position.x = int(position.x / SQ_SIZE) * SQ_SIZE + SQ_SIZE/2
	position.y = int(position.y / SQ_SIZE) * SQ_SIZE + SQ_SIZE/2

# Called when the node enters the scene tree for the first time.
func _ready():
	setInSquare()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
