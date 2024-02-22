extends Area2D
class_name Player

# Private variables
var tile_size : int = 16


# Export Variables
@export var input_timer : float = 0.1
@export var interaction_timer : float = 0.5
@export var animation_speed : float = 0.3
@export var action_buffer : float = 0.3

# Onready Variables
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var ray : RayCast2D = $RayCast2D
@onready var timer : Timer = $Timer
@onready var interaction_mgr : Node = get_node("InteractionManager")

# Signals
signal interacted

# Enum for "what lies ahead" type thing
enum Actions {MOVE, INTERACT, ATTACK, OTHER}

# Enum State Machine
enum States {IDLE, MOVING, INTERACTING, ATTACKING}
var current_state = States.IDLE
var initial_state = States.IDLE
var previous_state = States.IDLE

# Inputs
var input_directions = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_direction : String = "none"
	for dir in input_directions.keys():
		if Input.is_action_pressed(dir):
			input_direction = dir
			print("Input: " + dir)
			print(_look_ahead(dir))

func _interact(dir):
	pass
	
func _move(dir):
	print("Started moving")
	var tween = create_tween()
	tween.tween_property(self, "position", position + input_directions[dir] * tile_size, 
		animation_speed).set_trans(Tween.TRANS_LINEAR)
	
	if dir == "up":
		sprite.animation = "walk_up"
	elif dir == "down":
		sprite.animation = "walk_down"
	elif dir == "left":
		sprite.animation = "walk_left"
	elif dir == "right":
		sprite.animation = "walk_right"
	sprite.speed_scale = 2
	sprite.play()
	
	await tween.finished
	print("Finished moving")
	sprite.stop()

func _attack(dir):
	pass

func _look_ahead(dir)->int:
	#update the raycast
	ray.target_position = input_directions[dir] * tile_size
	ray.force_raycast_update()	
	if not ray.is_colliding(): # no collision, so the field is free and we can move
		return Actions.MOVE
	else: 	# if something, then what?
		var colliding_with = ray.get_collider()
		print(colliding_with) # DEBUG: Print what's there
		var groups = colliding_with.get_groups()
		print (groups) # DEBUG: Print the groups of what's there
		if "interactible" in groups:
			return Actions.INTERACT
		elif "enemy" in groups:
			return Actions.ATTACK
		else:
			return Actions.OTHER
