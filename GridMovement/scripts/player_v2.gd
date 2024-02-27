extends Area2D
class_name Player

# Private variables
var tile_size : int = 16
var move_tween : Tween
var move_buffer_direction : String = "none"


# Export Variables
@export var input_timer : float = 0.1
@export var interaction_timer : float = 0.5
@export var animation_speed : float = 0.3
@export var action_buffer : float = 0.3

# Onready Variables
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var ray : RayCast2D = $RayCast2D
@onready var timer : Timer = $Timer
@onready var move_buffer_timer : Timer = $MoveBufferTimer
@onready var interaction_mgr : Node = get_node("InteractionManager")
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

# Signals
signal interacted

# Enum for "what lies ahead" type thing
enum Actions {MOVE, INTERACT, ATTACK, OTHER}

# Enum State Machine
enum States {IDLE, MOVING, INTERACTING, ATTACKING}
var msg := {}
var current_state := States.IDLE
var initial_state := States.IDLE
var previous_state := States.IDLE

# 

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
	
	# set up our timers to be one shot
	timer.one_shot = true  # This one is used in interactions
	move_buffer_timer.one_shot = true  # This one is the move buffer
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ENUM - MATCH STATE MACHINE HERE
	var action_to_take : int = -1
	var action_direction : String = "none"
	
	# CHECK INPUT
	# CHECK FOR THE FOUR INPUT DIRECTION ACTIONS
	for dir in input_directions.keys():
		if Input.is_action_pressed(dir):
			action_direction = dir  # action_direction is reset every frame
			print("Input: " + dir)
	
	match current_state:
		# IDLE state should listen for input and change states accordingly
		States.IDLE:
			# IDLE can take action, so check what action can be take in the direction of input
			action_to_take = _look_ahead(action_direction)  # Set the action-to-take
			# Based on the result of action_to_take, change states if necessary
			match action_to_take:
				-1:  # NO ACTION TO TAKE
					pass
				Actions.MOVE:
					msg = {"dir": action_direction}
					_change_state(States.MOVING, msg)
				Actions.INTERACT:
					msg = {"dir": action_direction}
					_change_state(States.INTERACTING, msg)
				Actions.ATTACK:
					pass
				Actions.OTHER:
					pass
				
		States.MOVING:
			if not move_tween.is_running():  # If we have finished previous moving tween
				# Check if we want to move some more to immediately move again
				if _look_ahead(action_direction) == Actions.MOVE:
					print("MOVED IMMEDIATLY AFTER TWEEN")
					msg = {"dir": action_direction}  # Reassign msg with dir in case we change directions
					_change_state(States.MOVING, msg)  # Re-enter moving state with (new) direction
				elif _look_ahead(move_buffer_direction) == Actions.MOVE:
					print("MOVED IMMEDIATELY AFTER TWEEN FROM BUFFER")
					msg = {"dir": move_buffer_direction}  # Reassign msg with dir in case we change directions
					move_buffer_direction = "none"  # Clear the move buffer direction
					_change_state(States.MOVING, msg)  # Re-enter moving state with (new) direction
				else:  # Otherwise go back to idling
					print("MOVE OVER BACK TO IDLING")
					_change_state(States.IDLE)
			else:  # If tween is running, we listen for input to add to buffer
				for dir in input_directions.keys():
					if Input.is_action_just_pressed(dir):
						move_buffer_direction = dir
						move_buffer_timer.start(action_buffer)
						print("Buffer Input: " + dir)
		States.INTERACTING:
			if timer.is_stopped():
				_change_state(States.IDLE)
		States.ATTACKING:
			pass


func _interact(dir):
	print("Interacting " + dir)
	
	var animation_directions = {
		"up": "idle_up",
		"down": "idle_down",
		"left": "idle_left",
		"right": "idle_right",
	}
	sprite.animation = animation_directions[dir]
	
	var colliding_with = ray.get_collider()
	print("Interacting with: " + str(colliding_with))
	interacted.emit(colliding_with)
	timer.start(interaction_timer)


func _move(dir):
	print("Started moving")
	move_tween = create_tween()
	move_tween.tween_property(self, "position", position + input_directions[dir] * tile_size, 
		animation_speed).set_trans(Tween.TRANS_LINEAR)
	
	var animation_directions = {
		"up": "walk_up",
		"down": "walk_down",
		"left": "walk_left",
		"right": "walk_right",
	}
	
	sprite.animation = animation_directions[dir]
	sprite.speed_scale = 1.5
	if not sprite.is_playing():  # only start if not playing already
		sprite.play()
	
	await move_tween.finished
	print("Finished moving")
	

func _attack(dir):
	pass

func _look_ahead(dir)->int:
	if dir == "none":  # Break if "dir" is "none
		return -1
	else:
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

func _change_state(new_state: States, msg : Dictionary = {}):
	previous_state = current_state
	print("NEW STATE: " + str(new_state))
	match new_state:
		States.IDLE:
			current_state = States.IDLE
			match previous_state:
				States.MOVING:  # We go from MOVING to IDLE
					move_tween.kill()
					sprite.stop()  # stop the animation
					msg = {}  # clear msg
		States.MOVING:
			current_state = States.MOVING
			move_buffer_direction = "none"  # Clear move buffer so we don't move twice
			_move(msg["dir"])
		States.INTERACTING:
			current_state = States.INTERACTING
			_interact(msg["dir"])
		States.ATTACKING:
			current_state = States.ATTACKING
		_:
			print("Attempting to change to an unrecognised state.")
