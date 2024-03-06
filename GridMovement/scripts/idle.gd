class_name Idle
extends PlayerState

# IDLE state waits for input to take appropriate actions


func handle_input(event) -> void:
	var action_to_take : int = -1
	var action_direction : String = "none"
	
	# CHECK INPUT
	# CHECK FOR THE FOUR INPUT DIRECTION ACTIONS
	for dir in input_directions.keys():
		if event.is_action_pressed(dir):
			action_direction = dir  # action_direction is reset every frame
			print("SM Input: " + dir)
	
	# IF THERE IS DIRECTIONAL INPUT
	if action_direction != "none":
		match _look_ahead(action_direction):
			Actions.MOVE:
				print_debug("Transitioning to Moving.")
				state_machine.transition_to("Moving", {"dir": action_direction})
			Actions.INTERACT:
				pass
			Actions.OTHER:
				print("Ahead is OTHER, don't know what to do.")
		

func enter(msg:={}) -> void:
	pass
	
	
func exit() -> void:
	pass
	

func update(delta: float) -> void:
	pass
