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
	player.sprite.animation = animation_directions[msg["dir"]]  # Sets the correct direction for player to face
	
	var colliding_with = player.ray.get_collider()  # Get object we're interacting with
	print_debug("Interacting with: " + str(colliding_with))
	if colliding_with.has_method("get_interaction_bundle"):  # Check if it's interactible and has method
		var interaction_bundle: Resource = colliding_with.get_interaction_bundle()  # Get bundle
		if _interaction_pass(interaction_bundle):  # simple check if we pass for this interaction
			var method = interaction_bundle.method_self  # Pull the method from interaction bundle
			if method != null:
				colliding_with.call(method)  
	# player.interacted.emit(colliding_with)
	player.timer.start(player.interaction_timer)


func update(_delta : float) -> void:
	if player.timer.is_stopped():
		print_debug("Interaction timer done. Transitioning to Idle.")
		state_machine.transition_to("Idle")


func physics_update(_delta : float) -> void:
	pass

	
func exit() -> void:
	pass


func _interaction_pass(interaction_bundle: Resource):
	# now just return true, later check reqs
	return true
