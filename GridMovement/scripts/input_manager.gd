class_name InputManager extends Node

# INPUT MANAGER
# Takes all input and processes it
# States can always ask the Input Manager for input
# Types of input:
#-- DIRECTIONAL
#---- CONTINUOUS
#---- ISOLATED

#-- ACTION?
#-- TALK
#-- SPECIAL TOGGLES?
#---- Flying (Broomstick)

var input_dir_continuous : String = "none"
var input_dir_isolated : String = "none"

var input_directions = {
		"left": Vector2.LEFT,
		"right": Vector2.RIGHT,
		"up": Vector2.UP,
		"down": Vector2.DOWN,
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_dir_continuous = "none"
	input_dir_isolated = "none"
	for dir in input_directions.keys():
		if Input.is_action_pressed(dir):
			input_dir_continuous = dir
		if Input.is_action_just_pressed(dir):
			input_dir_isolated = dir
		
