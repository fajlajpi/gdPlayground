class_name Moving
extends PlayerState

@onready var input_manager = get_node("/root/InputMgr")

var move_tween : Tween
var move_buffer : String = "none"

	
func update(_delta : float) -> void:
	if move_tween.is_running():
		if input_manager.input_dir_isolated != "none":
			move_buffer = input_manager.input_dir_isolated
	else:
		#  BUFFER Only, no continuous input
		if input_manager.input_dir_continuous == "none" and move_buffer != "none":
			if _look_ahead(move_buffer) == Actions.MOVE:
				print_debug("Moving from BUFFER INPUT.")
				_move(move_buffer)
			move_buffer = "none"
		#  CONTINUOUS - we ignore buffer
		elif input_manager.input_dir_continuous != "none":
			if _look_ahead(input_manager.input_dir_continuous) == Actions.MOVE:
				print_debug("Moving from CONTINUOUS INPUT.")
				_move(input_manager.input_dir_continuous)

		else:  # No inputs, back to idle

			move_buffer = "none"
			state_machine.transition_to("Idle")


func physics_update(_delta : float) -> void:
	pass


func enter(_msg := {"dir":"none"}) -> void:
	print_debug("Entering MOVING state.")
	#if _msg["dir"] != "none":
	#	_move(_msg["dir"])
	move_tween = create_tween()
	move_tween.stop()
	#else:
	#	return
	
	
func exit() -> void:
	print_debug("Exiting MOVING.")
	player.sprite.stop()
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
