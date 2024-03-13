class_name Interacting
extends PlayerState


func enter(msg:={"dir": "none"}):
	print_debug("Interacting " + msg["dir"])
	
	var animation_directions = {
		"up": "idle_up",
		"down": "idle_down",
		"left": "idle_left",
		"right": "idle_right",
	}
	player.sprite.animation = animation_directions[msg["dir"]]
	
	var colliding_with = player.ray.get_collider()
	print_debug("Interacting with: " + str(colliding_with))
	player.interacted.emit(colliding_with)
	player.timer.start(player.interaction_timer)


func update(_delta : float) -> void:
	if player.timer.is_stopped():
		print_debug("Interaction timer done. Transitioning to Idle.")
		state_machine.transition_to("Idle")


func physics_update(_delta : float) -> void:
	pass

	
func exit() -> void:
	pass

