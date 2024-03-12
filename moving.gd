class_name Moving
extends PlayerState

var move_tween : Tween
var move_continuous : String = "none"
var move_buffer : String = "none"

func handle_input(_event : InputEvent) -> void:
	# CHECK INPUT
	# CHECK FOR THE FOUR INPUT DIRECTION ACTIONS
	# IF INPUT, ADD IT TO BUFFER
	print_debug("SM MOVING Input Getting handled:")
	for dir in input_directions.keys():
		if _event.is_action_pressed(dir, true):  # Input with ECHO
			move_continuous = dir
			print("SM:M Continuous Input: " + dir)
		if _event.is_action_pressed(dir, false):  # Input without ECHO
			move_buffer = dir
			print("SM:M Buffer Input: " + dir)
	
func update(_delta : float) -> void:
	if move_tween.is_running():
		move_continuous = "none"
	else:
		#  BUFFER Only, no continuous input
		if move_continuous == "none" and move_buffer != "none":
			if _look_ahead(move_buffer) == Actions.MOVE:
				print_debug("Moving from BUFFER INPUT.")
				_move(move_buffer)
			move_continuous = "none"
			move_buffer = "none"
		#  CONTINUOUS - we ignore buffer
		elif move_continuous != "none":
			if _look_ahead(move_continuous) == Actions.MOVE:
				print_debug("Moving from CONTINUOUS INPUT.")
				_move(move_continuous)
				move_continuous = "none"
		else:  # No inputs, back to idle
			state_machine.transition_to("Idle")

func physics_update(_delta : float) -> void:
	pass

func enter(_msg := {"dir":"none"}) -> void:
	print_debug("Entering MOVING state.")
	#if _msg["dir"] != "none":
	#	_move(_msg["dir"])
	move_tween = create_tween()
	move_tween.stop()
	move_buffer = _msg["dir"]
	move_continuous = "none"
	#else:
	#	return
	
func exit() -> void:
	print_debug("Exiting MOVING.")
	player.sprite.stop()
	move_continuous = "none"
	move_buffer = "none"
	move_tween.kill()

func _move(dir):
	print_debug("Started moving")
	move_tween = create_tween()
	move_tween.tween_property(player, "position", player.position + input_directions[dir] * player.tile_size, 
		player.animation_speed).set_trans(Tween.TRANS_LINEAR)
	
	var animation_directions = {
		"up": "walk_up",
		"down": "walk_down",
		"left": "walk_left",
		"right": "walk_right",
	}
	
	player.sprite.animation = animation_directions[dir]
	player.sprite.speed_scale = 1.5
	if not player.sprite.is_playing():  # only start if not playing already
		player.sprite.play()
	
	await move_tween.finished
	print_debug("Finished moving")
