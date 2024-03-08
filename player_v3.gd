class_name Player
extends Area2D

signal interacted

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
@onready var move_buffer_timer : Timer = $MoveBufferTimer
@onready var interaction_mgr : Node = get_node("InteractionManager")
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	
	# set up our timers to be one shot
	timer.one_shot = true  # This one is used in interactions
	move_buffer_timer.one_shot = true  # This one is the move buffer
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


