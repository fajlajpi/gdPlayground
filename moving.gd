class_name Moving
extends PlayerState

var move_tween : Tween
var move_buffer_continuous : String = "none"
var move_buffer_just_pressed : String = "none"

func handle_input(_event : InputEvent) -> void:
	# CHECK INPUT
	# CHECK FOR THE FOUR INPUT DIRECTION ACTIONS
	# IF INPUT, ADD IT TO BUFFER
	for dir in input_directions.keys():
		if _event.is_action_pressed(dir, true):
			if not move_tween.is_running():  # Take in continuous input only if tween has finished
				move_buffer_continuous = dir
				print("SM:M Continuous Input: " + dir)
		if _event.is_action_pressed(dir, false):  # Take buffer input only if tween is running
			if move_tween.is_running():
				move_buffer_just_pressed = dir
				print("SM:M Buffer Input: " + dir)
	
func update(_delta : float) -> void:
	if move_tween.is_running():
		move_buffer_continuous = "none"
	else:
		if move_buffer_continuous != "none":
			if _look_ahead(move_buffer_continuous) == Actions.MOVE:
				_move(move_buffer_continuous)
			move_buffer_continuous = "none"
		elif move_buffer_just_pressed != "none":
			if _look_ahead(move_buffer_just_pressed) == Actions.MOVE:
				_move(move_buffer_just_pressed)
				move_buffer_just_pressed = "none"
		else:  # No inputs, back to idle
			state_machine.transition_to("Idle")

func physics_update(_delta : float) -> void:
	pass

func enter(_msg := {"dir":"none"}) -> void:
	print_debug("Entering MOVING state.")
	if _msg["dir"] != "none":
		_move(_msg["dir"])
	else:
		return
	
func exit() -> void:
	print_debug("Exiting MOVING.")
	player.sprite.stop()
	move_buffer_continuous = "none"
	move_buffer_just_pressed = "none"
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
