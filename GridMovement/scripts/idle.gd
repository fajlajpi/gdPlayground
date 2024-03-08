class_name Idle
extends PlayerState

# IDLE state waits for input to take appropriate actions


func handle_input(event) -> void:
	var action_to_take : int = -1
	var action_direction : String = "none"
	
	# CHECK INPUT
	# CHECK FOR THE FOUR INPUT DIRECTION ACTIONS
	action_direction = _player_input(event)
	
	# IF THERE IS DIRECTIONAL INPUT
	if action_direction != "none":
		match _look_ahead(action_direction):
			Actions.MOVE:
				print_debug("Transitioning to Moving.")
				state_machine.transition_to("Moving", {"dir": action_direction})
			Actions.INTERACT:
				print_debug("Transitioning to Interacting.")
				state_machine.transition_to("Interacting", {"dir": action_direction})
			Actions.OTHER:
				print("Ahead is OTHER, don't know what to do.")
		

func enter(msg:={}) -> void:
	pass
	
	
func exit() -> void:
	pass
	

func update(delta: float) -> void:
	pass
