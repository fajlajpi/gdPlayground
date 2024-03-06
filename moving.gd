class_name Moving
extends PlayerState

var move_tween : Tween
var move_buffer_direction : String = "none"

func handle_input(_event : InputEvent) -> void:
	pass
	
func update(_delta : float) -> void:
	if not move_tween.is_running():
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
	print("Finished moving")
