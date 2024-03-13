extends Node

@onready var player : Area2D = $Player
signal mgr_interacted

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("interacted", _on_player_interacted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_interacted(colliding_with):
	print("Sent out a group action.")
	get_tree().call_group("interactible", "_on_player_interacted", colliding_with)
