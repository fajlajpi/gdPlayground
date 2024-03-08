class_name PlayerState
extends State

var player : Player

enum Actions {MOVE, INTERACT, OTHER}

var input_directions = {
		"left": Vector2.LEFT,
		"right": Vector2.RIGHT,
		"up": Vector2.UP,
		"down": Vector2.DOWN,
	}
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	
func _look_ahead(dir) -> Actions:
	if dir not in input_directions.keys():  # Break if "dir" is not found in dictionary keys
		return -1
	else:
		#update the raycast
		player.ray.target_position = input_directions[dir] * player.tile_size
		player.ray.force_raycast_update()	
		if not player.ray.is_colliding(): # no collision, so the field is free and we can move
			return Actions.MOVE
		else: 	# if something, then what?
			var colliding_with = player.ray.get_collider()
			print(colliding_with) # DEBUG: Print what's there
			var groups = colliding_with.get_groups()
			print (groups) # DEBUG: Print the groups of what's there
			if "interactible" in groups:
				return Actions.INTERACT
			else:
				return Actions.OTHER
