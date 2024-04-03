extends Area2D
class_name Interactible

@onready var interaction_mgr : Node = get_node("InteractionManager")
@export var interaction_bundle : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("interactible")
	

func _action():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_interacted(interactible):
	pass


func get_interaction_bundle():
	return interaction_bundle
