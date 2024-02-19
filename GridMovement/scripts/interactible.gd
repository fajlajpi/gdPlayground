extends Area2D
class_name Interactible

var interactible_types : Array = ["TOGGLE", "OTHER"]
@onready var interaction_mgr : Node = get_node("InteractionManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("interactible")
	pass # Replace with function body.

func _action():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_interacted(interactible):
	if interactible == self:
		print("Yay it's me!")
		_action()
	else:
		print("not me")
		pass
