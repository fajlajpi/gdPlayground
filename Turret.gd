extends CharacterBody2D


@export var TURNING_SPEED = 0.5 # TODO: what units is it?

func _physics_process(delta):

	look_at(get_global_mouse_position())
