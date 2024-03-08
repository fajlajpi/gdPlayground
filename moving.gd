class_name Moving
extends PlayerState

var move_tween := Tween.new()
var move_buffer_direction : String = "none"

func handle_input(_event : InputEvent) -> void:
	pass
	
func update(_delta : float) -> void:
	if not move_tween.is_running():
		for dir in input_directions.keys():  # check for input before going back to idle
			if Input.is_action_pressed(dir):  # If there is input in one of the directions...
				_move(dir)  # move in that direction
		# found no input, go back to idle
		state_machine.transition_to("Idle")

func physics_update(_delta : float) -> void:
	pass

func enter(_msg := {"dir":"none"}) -> void:
	print_debug("Entered MOVING state.")
	if _msg["dir"] != "none":
		_move(_msg["dir"])
	else:
		return
	
func exit() -> void:
	player.sprite.stop()

func _move(dir):
	# Only 1 valid tween at a time.
	if move_tween.is_valid():  # If we already have a valid tween, we abort
		print_debug("Tried to make a 2nd tween, aborted.")
		return
	
	print("Started moving")
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
	move_tween.kill()
	print("Finished moving")
