class_name Moving
extends PlayerState


func handle_input(_event : InputEvent) -> void:
	pass
	
func update(_delta : float) -> void:
	pass

func physics_update(_delta : float) -> void:
	pass

func enter(_msg := {}) -> void:
	print_debug("Entered MOVING state.")
	
func exit() -> void:
	pass
