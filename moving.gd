class_name Moving
extends PlayerState

var move_tween : Tween
var move_buffer_direction : String = "none"

func handle_input(_event : InputEvent) -> void:
	# CHECK INPUT
	# CHECK FOR THE FOUR INPUT DIRECTION ACTIONS
	# IF INPUT, ADD IT TO BUFFER
	var action_direction : String = "none"
	for dir in input_directions.keys():
		if _event.is_action_pressed(dir, true):
			move_buffer_direction = dir
			print("SM:M Input: " + dir)
	
	
func update(_delta : float) -> void:
	if not move_tween.is_running():
		if move_buffer_direction != "none":
			print_debug("Move ended, buffer not empty, check ahead.")
			match _look_ahead(move_buffer_direction):
				Actions.MOVE:
					_move(move_buffer_direction)
				_:
					state_machine.transition_to("Idle")
		else:
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
	move_buffer_direction = "none"

func _move(dir):
	print_debug("Started moving")
	move_buffer_direction = "none"
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
