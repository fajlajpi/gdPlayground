class_name PlayerState
extends State

var player : Player

enum Actions {MOVE, INTERACT, OTHER}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
