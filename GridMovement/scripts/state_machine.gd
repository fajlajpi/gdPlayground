class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var state : State = get_node(initial_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	for child in get_children():
		child.state_machine = self
	state.enter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	state.update(delta)
	
	
func _physics_process(delta : float) -> void:
	state.physics_update(delta)
	
	
func transition_to(target_state_name : String, msg : Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
	
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
